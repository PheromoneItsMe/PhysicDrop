/*
    ============================================================================
    EasyLife: PhysicDrop
    ============================================================================
    Author: Pheromone
    Compatibility: Autodesk 3ds Max 2020 - 2026 (Requires tyFlow)
    
    Installation:
    - Drag & drop this file into any 3ds Max viewport, OR
    - Copy into: %LOCALAPPDATA%\Autodesk\3dsMax\<Version>\ENU\usermacros\
    - Find under: Customize -> Customize User Interface -> Toolbars -> Category: [EasyLife]
    ============================================================================
*/

macroScript PhysicDrop
category:"EasyLife"
buttonText:"PhysicDrop"
toolTip:"EasyLife: PhysicDrop - In-place physical drop for multi-part models"
(
    global rollout_EasyLife_PhysicDrop
    
    rollout rollout_EasyLife_PhysicDrop "EasyLife: PhysicDrop" width:340 height:540
    (
        local staticNode = undefined
        local dynamicModels = #()
        local isSimulating = false
        local shouldAbort = false

        group " 1. Static Collider "
        (
            pickbutton pb_pickStatic "Pick Collider" width:100 across:3 align:#left tooltip:"Pick static container or surface in viewport"
            button btn_addStatic "Add Selected" width:100 align:#center tooltip:"Use selected object as static collider"
            button btn_clearStatic "Clear" width:80 align:#right tooltip:"Clear collider selection"
            edittext edt_static "Selected:" text:"None" readonly:true labelOntop:false
        )

        group " 2. Dynamic Models "
        (
            button btn_addDyn "+ Add Selected" width:100 across:3 align:#left tooltip:"Add selected objects or assemblies to drop list"
            button btn_removeDyn "- Remove" width:100 align:#center tooltip:"Remove selected item from list"
            button btn_clearDyn "Clear All" width:80 align:#right tooltip:"Clear drop list"
            
            listbox lb_dynamic "" items:#() height:8
            button btn_selInScene "Highlight in Scene" width:140 across:2 align:#left tooltip:"Select listed models in viewport"
            label lbl_count "Count: 0 models" align:#right offset:[0, 4]
        )

        group " 3. Simulation Settings "
        (
            checkbox chk_autoStop "Auto-Stop when motion settles" checked:true tooltip:"Automatically bake and stop when all objects stop moving"
            spinner spn_frames "Max Frames:" range:[10, 500, 60] type:#integer fieldWidth:50 across:2 align:#left
            spinner spn_gap "Contact Gap (mm):" range:[0.0, 5.0, 0.0] type:#float fieldWidth:50 align:#right
            spinner spn_friction "Friction:" range:[0.0, 1.0, 0.7] type:#float fieldWidth:50 across:2 align:#left
            spinner spn_bounciness "Bounciness:" range:[0.0, 1.0, 0.0] type:#float fieldWidth:50 align:#right
        )

        button btn_drop "START DROP & BAKE" width:310 height:38 highlightColor:(color 46 139 87) tooltip:"Simulate physical drop in-place and bake to models"
        button btn_stop "STOP" width:310 height:26 enabled:false highlightColor:(color 178 34 34) tooltip:"Stop simulation and bake current positions"
        progressBar pb_prog width:310 height:10 value:0
        label lbl_status "Status: Ready." align:#left

        fn findModelRoot node = (
            if not (isValidNode node) do return undefined
            if (isKindOf node Point) and (matchPattern node.name pattern:"*_POS") do return node
            local curr = node
            local highestModelHelper = node
            while curr != undefined do (
                if (isKindOf curr Point) and (matchPattern curr.name pattern:"*_POS") do return curr
                if (isKindOf curr Point) and not (matchPattern curr.name pattern:"*GRP*") do highestModelHelper = curr
                curr = curr.parent
            )
            highestModelHelper
        )

        fn collectAssemblyMeshes rootNode = (
            local meshes = #()
            local stack = #(rootNode)
            while stack.count > 0 do (
                local o = stack[stack.count]
                deleteItem stack stack.count
                if (superClassOf o == GeometryClass) do appendIfUnique meshes o
                for c in o.children do append stack c
            )
            meshes
        )

        fn buildCollisionProxy rootNode proxyName inflate = (
            local meshes = collectAssemblyMeshes rootNode
            if meshes.count == 0 do return undefined
            local snaps = for m in meshes collect (
                local s = snapshot m
                s.parent = undefined
                s
            )
            local px = snaps[1]
            convertToPoly px
            for i = 2 to snaps.count do polyop.attach px snaps[i]
            px.name = proxyName
            px.parent = undefined
            local numV = polyop.getNumVerts px
            local worldVerts = for v = 1 to numV collect (polyop.getVert px v)
            px.transform = rootNode.transform
            for v = 1 to numV do polyop.setVert px v worldVerts[v]
            if inflate > 0.0 do (
                local pu = Push()
                pu.Push_Value = inflate
                addModifier px pu
                collapseStack px
            )
            px
        )

        fn updateDynamicUI = (
            dynamicModels = for m in dynamicModels where isValidNode m collect m
            lb_dynamic.items = for m in dynamicModels collect m.name
            lbl_count.text = "Count: " + (dynamicModels.count as string) + " models"
        )

        on pb_pickStatic picked obj do (
            if isValidNode obj do (
                staticNode = obj
                edt_static.text = obj.name
            )
        )

        on btn_addStatic pressed do (
            if selection.count > 0 then (
                staticNode = selection[1]
                edt_static.text = staticNode.name
            ) else (
                messageBox "Please select a static collider object in the scene first." title:"PhysicDrop"
            )
        )

        on btn_clearStatic pressed do (
            staticNode = undefined
            edt_static.text = "None"
        )

        on btn_addDyn pressed do (
            if selection.count == 0 do (
                messageBox "Please select one or more objects in the scene to add." title:"PhysicDrop"
                return false
            )
            for s in selection do (
                local r = findModelRoot s
                if r != undefined do appendIfUnique dynamicModels r
            )
            updateDynamicUI()
        )

        on btn_removeDyn pressed do (
            local selIdx = lb_dynamic.selection
            if selIdx > 0 and selIdx <= dynamicModels.count do (
                deleteItem dynamicModels selIdx
                updateDynamicUI()
            )
        )

        on btn_clearDyn pressed do (
            dynamicModels = #()
            updateDynamicUI()
        )

        on btn_selInScene pressed do (
            local validNodes = for m in dynamicModels where isValidNode m collect m
            if validNodes.count > 0 do select validNodes
        )

        on btn_stop pressed do (
            if isSimulating do (
                shouldAbort = true
                lbl_status.text = "Stopping and baking current positions..."
            )
        )

        on btn_drop pressed do (
            if staticNode == undefined or not (isValidNode staticNode) do (
                messageBox "Please pick or select a static collider object first." title:"PhysicDrop"
                return false
            )
            if dynamicModels.count == 0 do (
                messageBox "Please add at least one dynamic model to drop." title:"PhysicDrop"
                return false
            )
            if tyFlow == undefined do (
                messageBox "tyFlow plugin is required for physical drop simulation.\nPlease install tyFlow (FREE or PRO)." title:"PhysicDrop"
                return false
            )

            local colliders = #()
            if (superClassOf staticNode == GeometryClass) then (
                append colliders staticNode
            ) else (
                colliders = collectAssemblyMeshes staticNode
            )
            if colliders.count == 0 do (
                messageBox "The static collider contains no valid geometry." title:"PhysicDrop"
                return false
            )

            lbl_status.text = "Building collision proxies..."
            pb_prog.value = 10
            windows.processPostedMessages()

            local proxies = #()
            local origRoots = #()
            local inflateVal = spn_gap.value * 0.5

            for i = 1 to dynamicModels.count do (
                local m = dynamicModels[i]
                local px = buildCollisionProxy m ("_EL_PX_" + (i as string)) inflateVal
                if px != undefined do (
                    append proxies px
                    append origRoots m
                )
            )

            if proxies.count == 0 do (
                messageBox "No valid geometry found in selected dynamic models." title:"PhysicDrop"
                pb_prog.value = 0
                lbl_status.text = "Status: Ready."
                return false
            )

            lbl_status.text = "Setting up PhysX simulation..."
            pb_prog.value = 20
            windows.processPostedMessages()

            local fl = tyFlow name:"_EL_DROP_FLOW"
            fl.interfaceParticleEnabled = true
            fl.physXGravityEnabled = true
            fl.physXGravityValue = -0.5
            fl.physXGroundCollider = false
            fl.physXSubsteps = 8
            fl.physXCCD = true

            local ev = fl.addEvent()
            local bo = ev.addOperator "Birth Objects" 0
            bo.objectList = proxies
            bo.objectsInheritGeometry = true
            bo.objectsCenterPivots = false
            bo.birthStart = 0
            bo.birthEnd = 0

            local ps = ev.addOperator "PhysX Shape" 1
            ps.hullMode = 2
            ps.restitution = spn_bounciness.value
            ps.staticFriction = spn_friction.value
            ps.dynamicFriction = spn_friction.value * 0.8

            local pc = ev.addOperator "PhysX Collision" 2
            pc.colliderList = colliders
            pc.hullMode = 3
            pc.testGeometry = true
            pc.restitution = spn_bounciness.value

            isSimulating = true
            shouldAbort = false
            btn_drop.enabled = false
            btn_stop.enabled = true

            local maxF = spn_frames.value
            local settled = false
            local finalFrame = maxF
            local vThresh = 0.05

            try (
                for f = 1 to maxF do (
                    if shouldAbort do (
                        finalFrame = f
                        exit
                    )
                    fl.updateParticles f
                    local pct = 20 + ((f as float) / maxF * 60)
                    pb_prog.value = pct
                    lbl_status.text = "Simulating frame " + (f as string) + "/" + (maxF as string) + "..."
                    windows.processPostedMessages()

                    if chk_autoStop.checked and f > 15 do (
                        local allStopped = true
                        for pIdx = 1 to proxies.count do (
                            local vel = length (fl.getParticleVelocity pIdx)
                            if vel > vThresh do (
                                allStopped = false
                                exit
                            )
                        )
                        if allStopped do (
                            finalFrame = f
                            settled = true
                            exit
                        )
                    )
                )

                lbl_status.text = "Baking resting transforms to models..."
                pb_prog.value = 85
                windows.processPostedMessages()

                undo "PhysicDrop" on (
                    for i = 1 to origRoots.count do (
                        local rootNode = origRoots[i]
                        local ptm = fl.getParticleTM i
                        if ptm != undefined do rootNode.transform = ptm
                    )
                )

                pb_prog.value = 100
                lbl_status.text = "Completed! (" + (finalFrame as string) + " frames, " + (origRoots.count as string) + " models placed)."
            ) catch (
                lbl_status.text = "Error during simulation: " + (getCurrentException())
            )

            delete fl
            for p in proxies where isValidNode p do delete p

            isSimulating = false
            btn_drop.enabled = true
            btn_stop.enabled = false
            completeRedraw()
        )
    )

    on execute do (
        try (destroyDialog rollout_EasyLife_PhysicDrop) catch ()
        createDialog rollout_EasyLife_PhysicDrop
        try (setFocus rollout_EasyLife_PhysicDrop) catch ()
    )
)

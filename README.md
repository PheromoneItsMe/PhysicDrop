# EasyLife: PhysicDrop

**Author:** Pheromone  
**Compatibility:** Autodesk 3ds Max 2020 – 2026  
**Required Plugin:** tyFlow (FREE or PRO)

---

## English

### Overview
**EasyLife: PhysicDrop** is a physics-based placement tool for Autodesk 3ds Max designed to simulate natural, realistic drops of 3D objects onto any static container or surface (desk organizers, cups, vases, trays, tables, shelves, floor).

Unlike traditional scatter or drop tools that randomly spawn objects across an area, **PhysicDrop** drops objects directly from their **current 3D in-air positions and orientations**, allowing for exact artistic control while achieving natural physical settling, natural lean angles, and resting contacts.

### Key Features
- **Multi-Part Model Integrity:** Specifically engineered for complex model assemblies (e.g. pens, scissors, tools with separate child meshes for metal, plastic, wood, paint). The simulation uses temporary collision proxies and bakes resting transforms back into root helpers. Original meshes are **never attached, collapsed, welded, or modified**.
- **100% Hierarchy Preservation:** Retains all parent-child relationships and relative offsets with sub-millimeter precision.
- **In-Place Physical Drop:** Objects fall and settle naturally from their current spatial coordinates.
- **Auto-Stop on Settle:** Automatically bakes transforms and stops simulation as soon as all motion stabilizes.
- **Full Undo Support:** Operations are wrapped in native 3ds Max undo blocks (`Ctrl+Z`).
- **Clean Scene:** Leaves zero simulation debris, temporary helpers, or extra modifiers.

### System Requirements
- Autodesk 3ds Max 2020, 2021, 2022, 2023, 2024, 2025, or 2026.
- **tyFlow plugin** (any build, either tyFlow FREE or tyFlow PRO).

### Installation
1. **Drag and Drop:** Simply drag `EasyLife_PhysicDrop_Installer.ms` into any active 3ds Max viewport.
2. The installer will automatically register the tool permanently under user macros and open the dialog window.
3. **Add Button to Toolbar:**
   - Go to **Customize** $\rightarrow$ **Customize User Interface** $\rightarrow$ **Toolbars**.
   - Under **Category**, choose **EasyLife**.
   - Drag the **PhysicDrop** action onto any desired toolbar.

### How to Use
1. Position your items (pens, pencils, props) in the air above your container (organizer, vase, shelf).
2. Open **PhysicDrop**.
3. In **1. Static Collider**, click **Pick Collider** and click your container (or select it and click **Add Selected**).
4. In **2. Dynamic Models**, select the objects you want to drop and click **+ Add Selected**.
5. Click **START DROP & BAKE**. The tool will run the physics, settle the objects naturally, and bake their resting positions.

---

## Русский

### Описание
**EasyLife: PhysicDrop** — инструмент физического размещения объектов в Autodesk 3ds Max, предназначенный для естественного сброса предметов в контейнеры или на поверхности (органайзеры, стаканы, вазы, полки, лотки, столы).

В отличие от стандартных скаттеров, сбрасывающих клоны по случайной сетке, **PhysicDrop** роняет выбранные предметы прямо из их **текущих координат в воздухе с сохранением их исходных углов**, обеспечивая реалистичные наклоны, упоры и точки контакта.

### Основные возможности
- **Сохранение целостности составных моделей:** Специально адаптирован для сложных сборок (ножницы, ручки, инструменты, состоящие из нескольких отдельных мешей под дерево, металл, краску). Физика рассчитывается через временные прокси, а результат запекается в корневой хелпер. Исходные меши **никогда не объединяются (no attach), не деформируются и не меняют материалов**.
- **100% сохранение иерархии:** Все дочерние связи и локальные смещения деталей сохраняются с абсолютной точностью (0.00 мм смещения).
- **Сброс по месту (In-Place):** Предметы падают строго со своих текущих позиций, без произвольного разбрасывания.
- **Авто-остановка при затухании:** Симуляция автоматически завершается и запекается, как только все объекты успокоились.
- **Поддержка отката (Ctrl+Z):** Результат можно мгновенно отменить стандартной комбинацией `Ctrl+Z`.
- **Чистота сцены:** В сцене не остаётся никаких временных объектов, лишних модификаторов или мусора.

### Системные требования
- Autodesk 3ds Max 2020, 2021, 2022, 2023, 2024, 2025 или 2026.
- Установленный плагин **tyFlow** (любая версия — tyFlow FREE или PRO).

### Установка
1. **Drag and Drop:** Перетащите файл `EasyLife_PhysicDrop_Installer.ms` мышкой прямо во вьюпорт 3ds Max.
2. Установщик автоматически зарегистрирует макрос в системе и сразу откроет окно инструмента.
3. **Вынос кнопки на панель:**
   - Откройте **Customize** $\rightarrow$ **Customize User Interface** $\rightarrow$ **Toolbars**.
   - В выпадающем списке **Category** выберите **EasyLife**.
   - Перетащите команду **PhysicDrop** на любую удобную панель инструментов.

### Инструкция по работе
1. Расположите предметы в воздухе над контейнером под нужными углами.
2. Откройте окно **PhysicDrop**.
3. В разделе **1. Static Collider** нажмите **Pick Collider** и кликните на контейнер/поверхность (или выделите его и нажмите **Add Selected**).
4. В разделе **2. Dynamic Models** выделите падающие предметы и нажмите **+ Add Selected**.
5. Нажмите **START DROP & BAKE**. Инструмент рассчитает физику падения, мягко уложит предметы в отсеки и зафиксирует их финальные координаты.

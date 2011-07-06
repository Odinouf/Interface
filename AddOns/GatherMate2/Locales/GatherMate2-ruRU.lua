-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "ruRU")
if not L then return end

L["Add this location to Cartographer_Waypoints"] = "Добавить эту локацию к точкам маршрута Cartographer"
L["Add this location to TomTom waypoints"] = "Добавить эту локацию к точкам маршрута TomTom"
L["Always show"] = "Всегда показывать"
L["Archaeology"] = "Археология"
L["Archaeology filter"] = "Фильтр Археологии"
L["Are you sure you want to delete all nodes from this database?"] = "Вы действительно хотите стереть все ноды из этой базы?"
L["Are you sure you want to delete all of the selected node from the selected zone?"] = "Вы действительно хотите удалить все выбранные ноды из выбранной зоны?"
L["Auto Import"] = "Авто-импорт"
L["Auto import complete for addon "] = "Завершен автоматический импорт для аддона"
L["Automatically import when ever you update your data module, your current import choice will be used."] = "Автоматический импорт при обновлении модуля данных, будут использоваться текущие настройки импорта."
L["CLEANUP_RADIUS_DESC"] = "Радиус в ярдах, в пределах которого определять ноды как дубликаты не записывать в базу. По умолчанию это |cffffd20050|r ярдов для Извлечения газа и |cffffd20015|r ярдов для всего остального. Эти же настройки используются при добавлении новых нодов."
L["Cataclysm"] = "Cataclysm"
L["Cleanup Complete."] = "Очистка закончена."
L["Cleanup Database"] = "Очистка БД"
L["Cleanup radius"] = "Радиус очистки"
L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = "Очистка вашей БД от дубликатов. Это займёт некоторое время, пожалуйста подождите."
L["Cleanup_Desc"] = "Со временем, ваша БД может сильно увеличиться в объеме. Во время очистки БД находятся и удаляются записи о нодах, находящихся слишком близко друг к другу, которые фактически являются одним и тем же нодом."
L["Clear database selections"] = "Очистить выбор БД."
L["Clear node selections"] = "Отмена выбора нод"
L["Clear zone selections"] = "Очистить выбор зон"
L["Color of the tracking circle."] = "Задаёт цвет метки слежения"
L["Control various aspects of node icons on both the World Map and Minimap."] = "Различные параметры отображения иконок на карте мира и миникарте"
L["Conversion_Desc"] = "Преобразование существующих данных GatherMate в формат GatherMate2."
L["Convert Databses"] = "Конвертация БД."
L["DATABASE_LOCKING_DESC"] = "Закрытие БД даёт вам возможность заморозить её текущее состояние. Ноды не будут добавляться, удаляться или изменяться. Это касается и операций очистки и импорта."
L["DELETE_ENTIRE_DESC"] = "Закрытие БД будет проигнорирована и все ноды во всех зонах этой БД будут удалены."
L["DELETE_SPECIFIC_DESC"] = "Удаляет все выбранные ноды из выбранной зоны. Вы должны отключить Закрытие БД чтобы это работало."
L["Database Locking"] = "Закрытие базы"
L["Database Maintenance"] = "Обслуживание БД"
L["Database locking"] = "Закрытие базы"
L["Databases to Import"] = "Базы для импортирования"
L["Databases you wish to import"] = "Базы, из которых вы хотите импортировать"
L["Delete"] = "Удалить"
L["Delete Entire Database"] = "Удалить всю базу данных"
L["Delete Specific Nodes"] = "Удаляем специфические ноды"
L["Delete selected node from selected zone"] = "Удалить выбранные ноды из выбранной зоны"
L["Display Settings"] = "Внешний вид"
L["Engineering"] = "Инженерное дело"
L["Expansion"] = "Дополнение"
L["Expansion Data Only"] = "Только данные дополнения"
L["FAQ"] = "ЧаВо"
L["FAQ_TEXT"] = [=[|cffffd200
Я только что поставил GatherMate, но на карте нет ни одной ноды. Что не так?
|r
GatherMate не поставляется вместе с данными. По мере того, как вы собираете травы, добываете полезные ископаемые или рыбачите, GatherMate будет добавлять новые записи на карту. Также, проверьте настройки Внешнего вида.

|cffffd200
Я вижу ноды на карте мира, но не вижу на миникарте! Теперь-то что не так?
|r
|cffffff78Minimap Button Bag|r (а возможно и другие аддоны) съедают все иконки, расположенные GatherMate-ом на миникарте. Выключите их.

|cffffd200
Как и где мне получить актуальную базу?
|r
Вы можете импортировать актуальную базу в GatherMate следующими способами:

1. |cffffff78GatherMate_Data|r - это LoD аддон содержит копию данных, добытых скриптами с WowHead (обновляется еженедельно). Есть опции автообновления

2. |cffffff78GatherMate_CartImport|r - Этот аддон позволяет вам импортировать модулей |cffffff78Cartographer_<Profession>|r в GatherMate. Чтобы заработало, и |cffffff78Cartographer_<Profession>|r modules и GatherMate_CartImport должны быть загружены и активны.

Заметьте, что импорт базы в GatherMate процесс не автоматический. Вам придётся самостоятельно залезть в раздел Импорт Данных и щелкнуть по кнопке "Импорт".

ОТличия от |cffffff78Cartographer_Data|r в том, что пользователю даётся выбор того, как и когда модифицировать данные, |cffffff78Cartographer_Data|r при загрузке просто перезапишет существующие базы без предупреждения и уничтожить все свеженайденные ноды.

|cffffd200
Вы можете добавить отображение локаций почтовых ящиков и мастеров полёта?
|r
Ответ - нет. Другой аддон или модуль от другого автора могут это сделать, ядро GatherMate этого делать не будет.

|cffffd200
Я нашёл баг! Куда слать багрепорт?
|r
Приём багов, жалоб и предложений - на |cffffff78http://www.wowace.com/forums/index.php?topic=10990.0|r

Также можете найти нас на |cffffff78irc://irc.freenode.org/wowace|r

Когда сообщаете о баге, убедитесь, что описали |cffffff78алгоритм воспроизведения бага|r, предоставили все |cffffff78сообщения об ошибках|r с трассировкой стека, если это возможно, предоставили |cffffff78номер ревизии|r GatherMate, в которой произошла проблема и информацию о том, |cffffff78какую языковую версию клиента вы используете|r.

Примечание: баги русификации постить сюда: |cffffff78http://forums.playhard.ru/index.php?showtopic=27192|r, авторы аддона ей не занимаются.

|cffffd200
Кто написал эту прелесть?
|r
Kagaro, Xinhuan, Nevcairiel and Ammo (поддержка русского от Dr.Jet Cheshirsky)
]=]
L["Failed to load GatherMateData due to "] = "Не могу загрузить GatherMateData, по причине "
L["Filter_Desc"] = "Выберите типы нод, которые вы хотите видеть на карте мира и миникарте. Не выбранные ноды всё равно будут записываться в базу."
L["Filters"] = "Фильтры"
L["Fish filter"] = "Фильтр рыбы"
L["Fishes"] = "Рыбы"
L["Fishing"] = "Рыбная ловля"
L["Frequently Asked Questions"] = "Часто Задаваемые Вопросы"
L["Gas Clouds"] = "Газовые облака"
L["Gas filter"] = "Фильтр газа"
L["GatherMate Conversion"] = "Преобразование GatherMate"
L["GatherMate Pin Options"] = "Настройки точек GatherMate"
L["GatherMate data has been imported."] = "GatherMateData был импортирован."
L["GatherMate2Data has been imported."] = "GatherMate2Data импортирован."
L["GatherMateData has been imported."] = "GatherMateData был импортирован."
L["General"] = "Основные"
L["Herb Bushes"] = "Травы"
L["Herb filter"] = "Фильтр трав"
L["Herbalism"] = "Травничество"
L["Icon Alpha"] = "Прозрачность иконок"
L["Icon Scale"] = "Масштаб иконок"
L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = "Позволяет выбрать прозрачность иконок. Только на карте мира."
L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = "Позволяет выбрать масштаб иконок на карте мира и миникарте."
L["Icons"] = "Иконки"
L["Import Data"] = "Импорт данных"
L["Import GatherMate2Data"] = "Импортировать GatherMate2Data"
L["Import GatherMateData"] = "Импортировать GatherMateData"
L["Import Options"] = "Опции импорта"
L["Import Style"] = "Вид импорта"
L["Importing_Desc"] = "Импортирование позволяет GatherMate получать данные нод из других источников помимо того, что вы сами находите в игре. После импотирования, вам возможно придётся провести операцию очистки."
L["Keybind to toggle Minimap Icons"] = "Привязка клавиши на отображение иконок"
L["Load GatherMate2Data and import the data to your database."] = "Загрузить GatherMate2Data и импортировать данные в вашу БД."
L["Load GatherMateData and import the data to your database."] = "Загрузить GatherMateData и импортировать данные в вашу БД."
L["Merge"] = "Слить"
L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = "Слияние допишет данные GatherMate2Data в вашу базу данных. Перезапись заменит вашу базу данных на данные GatherMate2Data."
L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = "Слияние допишет данные GatherMateData в вашу базу данных. Перезапись заменит вашу базу данных на данные GatherMateData."
L["Mine filter"] = "Фильтр руды"
L["Mineral Veins"] = "Рудные жилы"
L["Minimap Icon Tooltips"] = "Подсказки на мини-карте"
L["Mining"] = "Горное дело"
L["Never show"] = "Не показывать"
L["Only import selected expansion data from WoWDB"] = "Импортировать с WoWDB только данные выбранного дополнения"
L["Only import selected expansion data from WoWhead"] = "Импортировать с WoWDB только данные выбранного дополнения"
L["Only while tracking"] = "Только при поиске"
L["Only with digsite"] = "Только с зонами раскопок"
L["Only with profession"] = "По наличию профессии"
L["Overwrite"] = "Перезаписать"
L["Processing "] = "В процессе "
L["Select All"] = "Выбрать все"
L["Select Database"] = "Выбрать БД"
L["Select Databases"] = "Выбор бызы данных"
L["Select Node"] = "Выбрать ноду"
L["Select None"] = "Отменить выбор"
L["Select Zone"] = "Выбрать зону"
L["Select Zones"] = "Выбор зон"
L["Select all databases"] = "Выбрать все БД."
L["Select all nodes"] = "Выбирает все ноды"
L["Select all zones"] = "Выбрать все зоны"
L["Select the archaeology nodes you wish to display."] = "Выберите ноды архиалогии для отображения."
L["Select the fish nodes you wish to display."] = "Выберите ноды рыбы для отображения"
L["Select the gas clouds you wish to display."] = "Выберите газовые облака для отображения"
L["Select the herb nodes you wish to display."] = "Выберите ноды трав для отображения"
L["Select the mining nodes you wish to display."] = "Выберите ноды руды для отображения"
L["Select the treasure you wish to display."] = "Выберите сокровища для отображения"
L["Selected databases are shown on both the World Map and Minimap."] = "Выбранные базы данных отображаются как на карте мира, так и на миникарте."
L["Show Archaeology Nodes"] = "Показать Археологические ноды"
L["Show Databases"] = "Показать базы данных"
L["Show Fishing Nodes"] = "Рыбные места"
L["Show Gas Clouds"] = "Газовые облака"
L["Show Herbalism Nodes"] = "Поиск трав"
L["Show Minimap Icons"] = "Иконки на миникарте."
L["Show Mining Nodes"] = "Поиск минералов"
L["Show Nodes on Minimap Border"] = "Ноды на границе миникарты"
L["Show Tracking Circle"] = "Показать метку слежения"
L["Show Treasure Nodes"] = "Сокровища"
L["Show World Map Icons"] = "Иконки на карте мира"
L["Shows more Nodes that are currently out of range on the minimap's border."] = "Показывает ноды, фактически находящиеся ЗА границами миникарты."
L["The Burning Crusades"] = "The Burning Crusades"
L["The Frozen Sea"] = "Ледяное море"
L["The North Sea"] = "Северное море"
L["The distance in yards to a node before it turns into a tracking circle"] = "Расстояние в ярдах до ноды, на котором вокруг неё появится круг - метка слежения"
L["Toggle showing Minimap icon tooltips."] = "Вкл/Выкл показ подсказок на миникарте"
L["Toggle showing Minimap icons."] = "Вкл/Выкл показ иконок на миникарте."
L["Toggle showing World Map icons."] = "Вкл/Выкл показ иконок на карте мира."
L["Toggle showing archaeology nodes."] = "Включить показывать археологические ноды"
L["Toggle showing fishing nodes."] = "Вкл/Выкл показ рыбных мест."
L["Toggle showing gas clouds."] = "Вкл/Выкл показ газовых облаков."
L["Toggle showing herbalism nodes."] = "Вкл/Выкл показ трав."
L["Toggle showing mining nodes."] = "Вкл/Выкл показ минералов."
L["Toggle showing the tracking circle."] = "Вкл/выкл отображение метки слежения"
L["Toggle showing treasure nodes."] = "Вкл/Выкл показ сокровищ."
L["Tracking Circle Color"] = "Цвет метки слежения"
L["Tracking Distance"] = "Радиус радара"
L["Treasure"] = "Сокровища"
L["Treasure filter"] = "Фильтр сокровищ"
L["Wrath of the Lich King"] = "Wrath of the Lich King"


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "ruRU")
if not NL then return end

NL["'Small Obsidian Chunk"] = "Маленький кусочек обсидиана"
NL["Abundant Bloodsail Wreckage"] = "Крупные обломки кораблекрушения шайки Кровавого Паруса"
NL["Abundant Firefin Snapper School"] = "Крупный косяк огнеперого луциана"
NL["Abundant Oily Blackmouth School"] = "Крупный косяк масляного черноротика"
NL["Adamantite Bound Chest"] = "Сундук, окованный адамантитом"
NL["Adamantite Deposit"] = "Залежи адамантита"
NL["Adder's Tongue"] = "Язык аспида"
NL["Albino Cavefish School"] = "Косяк слепоглазок-альбиносов"
NL["Algaefin Rockfish School"] = "Косяк водорослевых скорпен"
NL["Ancient Lichen"] = "Древний лишайник"
NL["Arcane Vortex"] = "Волшебное завихрение"
NL["Arctic Cloud"] = "Снежный шар"
NL["Arthas' Tears"] = "Слезы Артаса"
NL["Azshara's Veil"] = "Вуаль Азшары"
NL["Battered Chest"] = "Побитый сундук"
NL["Battered Footlocker"] = "Побитый сундучок"
NL["Black Lotus"] = "Черный лотос"
NL["Blackbelly Mudfish School"] = "Косяк илистого чернобрюха"
NL["Blindweed"] = "Пастушья сумка"
NL["Blood of Heroes"] = "Кровь Героев"
NL["Bloodpetal Sprout"] = "Побег кровоцвета"
NL["Bloodsail Wreckage"] = "Обломки кораблекрушения шайки Кровавого Паруса"
NL["Bloodthistle"] = "Кровопийка"
NL["Bloodvine"] = "Кровавая лоза"
NL["Bluefish School"] = "Косяк луфаря"
NL["Borean Man O' War School"] = "Косяк борейского медузника"
NL["Bound Adamantite Chest"] = "Сундук, окованный адамантитом"
NL["Bound Fel Iron Chest"] = "Сундук, окованный оскверненным железом"
NL["Brackish Mixed School"] = "Косяк сквернохвоста"
NL["Briarthorn"] = "Остротерн"
NL["Brightly Colored Egg"] = "Раскрашенное яйцо"
NL["Bruiseweed"] = "Синячник"
NL["Buccaneer's Strongbox"] = "Сейф буканьера"
NL["Burial Chest"] = "Погребальный сундук"
NL["Cinder Cloud"] = "Облако золы"
NL["Cinderbloom"] = "Пепельник"
NL["Cobalt Deposit"] = "Залежи кобальта"
NL["Copper Vein"] = "Медная жила"
NL["Dark Iron Deposit"] = "Залежи черного железа"
NL["Dark Iron Treasure Chest"] = "Сундук с сокровищами Черного Железа"
NL["Deep Sea Monsterbelly School"] = "Косяк глубоководного чертобрюха"
NL["Dented Footlocker"] = "Проломленный сундучок"
NL["Draenei Archaeology Find"] = "Дренейская археологическая находка"
NL["Dragon's Teeth"] = "Драконьи зубы"
NL["Dragonfin Angelfish School"] = "Косяк дракоперой рыбы-ангела"
NL["Dreamfoil"] = "Снолист"
NL["Dreaming Glory"] = "Сияние грез"
NL["Dwarf Archaeology Find"] = "Дворфийская археологическая находка"
NL["Earthroot"] = "Земляной корень"
NL["Elementium Vein"] = "Элементиевая жила"
NL["Everfrost Chip"] = "Осколок Вечного льда"
NL["Fadeleaf"] = "Бледнолист"
NL["Fangtooth Herring School"] = "Косяк сельди-батиприона"
NL["Fathom Eel Swarm"] = "Стайка сажневого угря"
NL["Fel Iron Chest"] = "Сундук из оскверненного железа"
NL["Fel Iron Deposit"] = "Месторождение оскверненного железа"
NL["Felmist"] = "Туман Скверны"
NL["Felsteel Chest"] = "Сундук из оскверненной стали"
NL["Feltail School"] = "Косяк сквернохвоста"
NL["Felweed"] = "Сквернопля"
NL["Firebloom"] = "Огнецвет"
NL["Firefin Snapper School"] = "Косяк огнеперого луциана"
NL["Firethorn"] = "Огница"
NL["Flame Cap"] = "Огненный зев"
NL["Floating Debris"] = "Плавающий мусор"
NL["Floating Wreckage"] = "Плавающие обломки"
NL["Floating Wreckage Pool"] = "Обломки в воде"
NL["Fossil Archaeology Find"] = "Находка-окаменелость"
NL["Frost Lotus"] = "Северный лотос"
NL["Frozen Herb"] = "Мерзлая трава"
NL["Ghost Mushroom"] = "Призрачная поганка"
NL["Giant Clam"] = "Гигантский моллюск"
NL["Glacial Salmon School"] = "Косяк ледникового лосося"
NL["Glassfin Minnow School"] = "Косяк ледоспинки"
NL["Glowcap"] = "Пламеневик"
NL["Gold Vein"] = "Золотая жила"
NL["Goldclover"] = "Золотой клевер"
NL["Golden Sansam"] = "Золотой сансам"
NL["Goldthorn"] = "Златошип"
NL["Grave Moss"] = "Могильный мох"
NL["Greater Sagefish School"] = "Косяк большого шалфокуня"
NL["Gromsblood"] = "Кровь Грома"
NL["Heartblossom"] = "Цветущее сердце"
NL["Heavy Fel Iron Chest"] = "Тяжелый Сундук из оскверненного железа"
NL["Highland Guppy School"] = "Косяк высокогорных гуппи"
NL["Highland Mixed School"] = "Смешанный косяк нагорья"
NL["Huge Obsidian Slab"] = "Громадный кусок обсидиана"
NL["Icecap"] = "Ледяной зев"
NL["Icethorn"] = "Ледошип"
NL["Imperial Manta Ray School"] = "Косяк императорского морского дьявола"
NL["Incendicite Mineral Vein"] = "Ароматитовая жила"
NL["Indurium Mineral Vein"] = "Индарилиевая жила"
NL["Iron Deposit"] = "Залежи железа"
NL["Khadgar's Whisker"] = "Кадгаров ус"
NL["Khorium Vein"] = "Кориевая жила"
NL["Kingsblood"] = "Королевская кровь"
NL["Large Battered Chest"] = "Большой побитый сундук"
NL["Large Darkwood Chest"] = "Большой сундук Темного Леса"
NL["Large Iron Bound Chest"] = "Большой сундук, окованный железом"
NL["Large Mithril Bound Chest"] = "Большой сундук, окованный мифрилом"
NL["Large Obsidian Chunk"] = "Большая обсидиановая глыба"
NL["Large Solid Chest"] = "Большой добротный сундук"
NL["Lesser Bloodstone Deposit"] = "Малое месторождение кровавого камня"
NL["Lesser Firefin Snapper School"] = "Малый косяк огнеперого луциана"
NL["Lesser Floating Debris"] = "Малый плавающий мусор"
NL["Lesser Oily Blackmouth School"] = "Малый косяк масляного черноротика"
NL["Lesser Sagefish School"] = "Малый косяк шалфокуня"
NL["Lichbloom"] = "Личецвет"
NL["Liferoot"] = "Корень жизни"
NL["Mageroyal"] = "Магороза"
NL["Mana Thistle"] = "Манаполох"
NL["Maplewood Treasure Chest"] = "Кленовый сундук с сокровищами"
NL["Mithril Deposit"] = "Мифриловые залежи"
NL["Moonglow Cuttlefish School"] = "Стая каракатиц лунного сияния"
NL["Mossy Footlocker"] = "Замшелый сундучок"
NL["Mountain Silversage"] = "Горный серебряный шалфей"
NL["Mountain Trout School"] = "Косяк горной форели"
NL["Muddy Churning Water"] = "Грязный водоворот"
NL["Mudfish School"] = "Косяк ильной рыбы"
NL["Musselback Sculpin School"] = "Косяк бычка-щитоспинки"
NL["Mysterious Camel Figurine"] = "Странная фигурка верблюда"
NL["Nerubian Archaeology Find"] = "Нерубская археологическая находка"
NL["Netherbloom"] = "Пустоцвет"
NL["Nethercite Deposit"] = "Месторождение хаотита"
NL["Netherdust Bush"] = "Куст пустопраха"
NL["Netherwing Egg"] = "Яйцо дракона из стаи Крыльев Пустоты"
NL["Nettlefish School"] = "Стайка медуз"
NL["Night Elf Archaeology Find"] = "Эльфийская археологическая находка"
NL["Nightmare Vine"] = "Ползучий кошмарник"
NL["Obsidian Chunk"] = "Обсидиановая глыба"
NL["Obsidium Deposit"] = "Залежи обсидиана"
NL["Oil Spill"] = "Нефтяное пятно"
NL["Oily Blackmouth School"] = "Косяк масляного черноротика"
NL["Ooze Covered Gold Vein"] = "Покрытая слизью золотая жила"
NL["Ooze Covered Mithril Deposit"] = "Покрытые слизью мифриловые залежи"
NL["Ooze Covered Rich Thorium Vein"] = "Покрытая слизью богатая ториевая жила"
NL["Ooze Covered Silver Vein"] = "Покрытая слизью серебрянная жила"
NL["Ooze Covered Thorium Vein"] = "Покрытая слизью ториевая жила"
NL["Ooze Covered Truesilver Deposit"] = "Покрытые слизью залежи истинного серебра"
NL["Orc Archaeology Find"] = "Оркская археологическая находка"
NL["Other Archaeology Find"] = "Другие Археологические поиски"
NL["Patch of Elemental Water"] = "Участок стихийной воды"
NL["Peacebloom"] = "Мироцвет"
NL["Plaguebloom"] = "Чумоцвет"
NL["Pool of Fire"] = "Лужа огня"
NL["Practice Lockbox"] = "Учебный денежный ящик"
NL["Primitive Chest"] = "Примитивный сундук"
NL["Pure Saronite Deposit"] = "Месторождение чистого саронита"
NL["Pure Water"] = "Чистая вода"
NL["Purple Lotus"] = "Лиловый лотос"
NL["Pyrite Deposit"] = "Залежи колчедана"
NL["Ragveil"] = "Кисейница"
NL["Rich Adamantite Deposit"] = "Богатые залежи адамантита"
NL["Rich Cobalt Deposit"] = "Богатые залежи кобальта"
NL["Rich Elementium Vein"] = "Богатая элементиевая жила"
NL["Rich Obsidium Deposit"] = "Богатые Обсидиановые залежи"
NL["Rich Pyrite Deposit"] = "Богатые залежи колчедана"
NL["Rich Saronite Deposit"] = "Богатое месторождение саронита"
NL["Rich Thorium Vein"] = "Богатая ториевая жила"
NL["Runestone Treasure Chest"] = "Инкрустированный руническими камнями сундук с сокровищами"
NL["Sagefish School"] = "Косяк шалфокуня"
NL["Saronite Deposit"] = "Месторождение саронита"
NL["Scarlet Footlocker"] = "Сундучок Алых"
NL["School of Darter"] = "Косяк змеешейки"
NL["School of Deviate Fish"] = "Косяк загадочной рыбы"
NL["School of Tastyfish"] = "Косяк вкуснорыбы"
NL["Schooner Wreckage"] = "Разбитая шхуна"
NL["Shipwreck Debris"] = "Обломки кораблекрушения"
NL["Silken Treasure Chest"] = "Шелковый сундук с сокровищами"
NL["Silver Vein"] = "Серебряная жила"
NL["Silverbound Treasure Chest"] = "Окованный серебром сундук с сокровищами"
NL["Silverleaf"] = "Сребролист"
NL["Small Obsidian Chunk"] = "Маленький кусочек обсидиана"
NL["Small Thorium Vein"] = "Малая ториевая жила"
NL["Solid Chest"] = "Добротный сундук"
NL["Solid Fel Iron Chest"] = "Добротный сундук из оскверненного железа"
NL["Sorrowmoss"] = "Печаль-трава"
NL["Sparse Firefin Snapper School"] = "Небольшой косяк огнеперого луциана"
NL["Sparse Oily Blackmouth School"] = "Небольшой косяк масляного черноротика"
NL["Sparse Schooner Wreckage"] = "Небольшая разбитая шхуна"
NL["Sporefish School"] = "Косяк спороуса"
NL["Steam Cloud"] = "Паровое облако"
NL["Steam Pump Flotsam"] = "Обломки парового насоса"
NL["Stonescale Eel Swarm"] = "Стайка каменного угря"
NL["Stormvine"] = "Ливневая лоза"
NL["Strange Pool"] = "Странный водоем"
NL["Stranglekelp"] = "Удавник"
NL["Sturdy Treasure Chest"] = "Прочный сундук с сокровищами"
NL["Sungrass"] = "Солнечник"
NL["Swamp Gas"] = "Болотный газ"
NL["Talandra's Rose"] = "Роза Таландры"
NL["Tattered Chest"] = "Побитый сундук"
NL["Teeming Firefin Snapper School"] = "Большой косяк огнеперого луциана"
NL["Teeming Floating Wreckage"] = "Большие плавающие обломки"
NL["Teeming Oily Blackmouth School"] = "Большой косяк масляного черноротика"
NL["Terocone"] = "Терошишка"
NL["Tiger Lily"] = "Тигровая лилия"
NL["Tin Vein"] = "Оловянная жила"
NL["Titanium Vein"] = "Залежи титана"
NL["Tol'vir Archaeology Find"] = "Тол'вирская археологическая находка"
NL["Troll Archaeology Find"] = "Тролльская археологическая находка"
NL["Truesilver Deposit"] = "Залежи истинного серебра"
NL["Twilight Jasmine"] = "Сумеречный жасмин"
NL["Un'Goro Dirt Pile"] = "Куча грязи из Ун'Горо"
NL["Vrykul Archaeology Find"] = "Врайкульская археологическая находка"
NL["Waterlogged Footlocker"] = "Затопленный сундучок"
NL["Waterlogged Wreckage"] = "Плавающие обломки"
NL["Whiptail"] = "Хлыстохвост"
NL["Wicker Chest"] = "Ларец из лозы"
NL["Wild Steelbloom"] = "Дикий сталецвет"
NL["Windy Cloud"] = "Грозовое облако"
NL["Wintersbite"] = "Морозник"


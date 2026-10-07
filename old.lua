local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local Env = (getgenv and getgenv()) or _G
if type(Env.VortexUnload) == "function" then pcall(Env.VortexUnload); Env.VortexUnload = nil end

local Locale = {Current = "EN", Registry = {}, Listeners = {}, Strings = {EN = {}, UA = {}, RU = {}}}
local function L(k, en, ua, ru) Locale.Strings.EN[k] = en; Locale.Strings.UA[k] = ua; Locale.Strings.RU[k] = ru end

L("APP_NAME","VORTEX","VORTEX","VORTEX")
L("APP_SUB","COMBAT HUB","БОЙОВИЙ ХАБ","БОЕВОЙ ХАБ")
L("TAB_AIMBOT","AIMBOT","АЙМБОТ","АИМБОТ")
L("TAB_VISUALS","VISUALS","ВІЗУАЛ","ВИЗУАЛ")
L("TAB_MOVEMENT","MOVEMENT","РУХ","ДВИЖЕНИЕ")
L("TAB_PRESETS","PRESETS","ПРЕСЕТИ","ПРЕСЕТЫ")
L("TAB_RENDERING","RENDERING","РЕНДЕРИНГ","РЕНДЕРИНГ")
L("TAB_CAMERA","CAMERA","КАМЕРА","КАМЕРА")
L("TAB_WEATHER","WEATHER","ПОГОДА","ПОГОДА")
L("TAB_CROSSHAIR","CROSSHAIR","ПРИЦІЛ","ПРИЦЕЛ")
L("TAB_PROFILE","PROFILE","ПРОФІЛЬ","ПРОФИЛЬ")
L("TAB_DEBUG","LOGS","ЛОГИ","ЛОГИ")
L("TAB_BINDS","BINDS","КЛАВІШІ","КЛАВИШИ")
L("TAB_SETTINGS","SETTINGS","НАЛАШТУВАННЯ","НАСТРОЙКИ")
L("MENU_KEY","MENU KEY","КЛАВІША МЕНЮ","КЛАВИША МЕНЮ")
L("SEC_AIMBOT","AIMBOT","АЙМБОТ","АИМБОТ")
L("SEC_TRIGGER","TRIGGER BOT","ТРИГЕР БОТ","ТРИГГЕР БОТ")
L("SEC_ESP","ESP","ESP","ESP")
L("SEC_MOVEMENT","MOVEMENT","РУХ","ДВИЖЕНИЕ")
L("SEC_PRESETS","PRESETS","ПРЕСЕТИ","ПРЕСЕТЫ")
L("SEC_RENDERING","RENDERING","РЕНДЕРИНГ","РЕНДЕРИНГ")
L("SEC_CAMERA","CAMERA","КАМЕРА","КАМЕРА")
L("SEC_WEATHER","WEATHER","ПОГОДА","ПОГОДА")
L("SEC_ATMOSPHERE","ATMOSPHERE","АТМОСФЕРА","АТМОСФЕРА")
L("SEC_TIME","TIME","ЧАС","ВРЕМЯ")
L("SEC_POSTFX","POST FX","ПОСТ ЕФЕКТИ","ПОСТ ЭФФЕКТЫ")
L("SEC_CROSSHAIR","CROSSHAIR","ПРИЦІЛ","ПРИЦЕЛ")
L("SEC_HITFX","HIT FEEDBACK","ВІДГУК ПОПАДАННЯ","ОТКЛИК ПОПАДАНИЯ")
L("SEC_SESSION","SESSION","СЕСІЯ","СЕССИЯ")
L("SEC_ACCOUNT","ACCOUNT","АКАУНТ","АККАУНТ")
L("SEC_SERVER","SERVER","СЕРВЕР","СЕРВЕР")
L("SEC_INTERFACE","INTERFACE","ІНТЕРФЕЙС","ИНТЕРФЕЙС")
L("SEC_THEME","THEME CUSTOMIZATION","КАСТОМІЗАЦІЯ ТЕМИ","КАСТОМИЗАЦИЯ ТЕМЫ")
L("SEC_CONFIG","CONFIG","КОНФІГ","КОНФИГ")
L("SEC_SCRIPT","SCRIPT","СКРИПТ","СКРИПТ")
L("SEC_LANGUAGE","LANGUAGE","МОВА","ЯЗЫК")
L("SEC_LOG","LOG REPORT","ЗВІТ ЛОГІВ","ОТЧЁТ ЛОГОВ")
L("LBL_ERRORSTATUS","Error Status","Стан помилок","Статус ошибок")
L("OPT_AIMBOT","Aimbot","Аймбот","Аимбот")
L("OPT_HOLD_RMB","Hold Right Mouse","Утримувати ПКМ","Удерживать ПКМ")
L("OPT_TEAMCHECK","Team Check","Перевірка команди","Проверка команды")
L("OPT_VISIBLECHECK","Visible Check","Перевірка видимості","Проверка видимости")
L("OPT_AIMPART","Aim Part","Частина прицілу","Часть прицела")
L("OPT_AIMSPEED","Aim Speed","Швидкість прицілу","Скорость прицела")
L("OPT_FOVRADIUS","FOV Radius","Радіус FOV","Радиус FOV")
L("OPT_MAXDIST","Max Distance","Макс. дистанція","Макс. дистанция")
L("OPT_PREDICTION","Movement Prediction","Прогноз руху","Прогноз движения")
L("OPT_PREDICTIONTIME","Prediction Time","Час прогнозу","Время прогноза")
L("OPT_SHOWFOV","Show FOV Circle","Показати коло FOV","Показать круг FOV")
L("OPT_TARGETLINE","Target Line","Лінія до цілі","Линия к цели")
L("OPT_TRIGGERBOT","Trigger Bot","Тригер бот","Триггер бот")
L("OPT_TRIGGERFOV","Trigger FOV","FOV тригера","FOV триггера")
L("OPT_SHOWTRIGGERFOV","Show Trigger FOV","Показати FOV тригера","Показать FOV триггера")
L("OPT_HITBOX","Include Hitbox Size","Врахувати хітбокс","Учитывать хитбокс")
L("OPT_TRIGGERPART","Trigger Part","Частина тригера","Часть триггера")
L("OPT_WALLCHECK","Wall Check","Перевірка стін","Проверка стен")
L("OPT_ONLYAIM","Only While Aiming (RMB)","Лише під час прицілювання","Только при прицеливании")
L("OPT_REACTDELAY","Reaction Delay","Затримка реакції","Задержка реакции")
L("OPT_FIREINTERVAL","Fire Interval","Інтервал вогню","Интервал огня")
L("OPT_HUMANIZE","Humanize Timing","Гуманізація таймінгу","Гуманизация тайминга")
L("OPT_CLICKMODE","Click Mode","Режим кліку","Режим клика")
L("OPT_IGNOREBOT","Ignore Bot","Ігнорувати ботів","Игнорировать ботов")
L("BOT_LABEL","BOT","БОТ","БОТ")
L("OPT_ESP","ESP","ESP","ESP")
L("OPT_HIDETEAM","Hide Teammates","Приховати команду","Скрыть команду")
L("OPT_BOXES","Boxes","Рамки","Рамки")
L("OPT_CORNERBOXES","Corner Boxes","Кутові рамки","Угловые рамки")
L("OPT_NAMES","Names","Імена","Имена")
L("OPT_DISTANCE","Distance","Дистанція","Дистанция")
L("OPT_HEALTHBAR","Health Bar","Смуга здоров'я","Полоса здоровья")
L("OPT_SKELETON","Skeleton","Скелет","Скелет")
L("OPT_HEADDOT","Head Dot","Точка на голові","Точка на голове")
L("OPT_WEAPON","Weapon","Зброя","Оружие")
L("OPT_OFFSCREEN","Offscreen Arrows","Стрілки поза екраном","Стрелки вне экрана")
L("OPT_CHAMS","Chams","Чамс","Чамс")
L("OPT_TRACERS","Tracers","Трасери","Трейсеры")
L("OPT_TRACERORIGIN","Tracer Origin","Початок трасера","Начало трейсера")
L("OPT_ESPCOLOR","ESP Color","Колір ESP","Цвет ESP")
L("OPT_ESPDIST","ESP Distance","Дистанція ESP","Дистанция ESP")
L("OPT_SPEED","Speed","Швидкість","Скорость")
L("OPT_WALKSPEED","Walk Speed","Швидкість ходьби","Скорость ходьбы")
L("OPT_JUMPPOWER","Jump Power","Сила стрибка","Сила прыжка")
L("OPT_JUMPVALUE","Jump Value","Значення стрибка","Значение прыжка")
L("OPT_FLY","Fly","Політ","Полёт")
L("OPT_FLYSPEED","Fly Speed","Швидкість польоту","Скорость полёта")
L("OPT_NOCLIP","Noclip","Ноукліп","Ноуклип")
L("OPT_INFJUMP","Infinite Jump","Нескінченний стрибок","Бесконечный прыжок")
L("OPT_SCENEPRESET","Scene Preset","Пресет сцени","Пресет сцены")
L("OPT_FULLBRIGHT","Full Bright","Повна яскравість","Полная яркость")
L("OPT_NOSHADOWS","No Shadows","Без тіней","Без теней")
L("OPT_EXPOSURE","Exposure Override","Перекрити експозицію","Переопределить экспозицию")
L("OPT_EXPOSUREVAL","Exposure","Експозиція","Экспозиция")
L("OPT_HIDECLOUDS","Hide Clouds","Приховати хмари","Скрыть облака")
L("OPT_GRAVITY","Gravity Override","Перекрити гравітацію","Переопределить гравитацию")
L("OPT_GRAVITYVAL","Gravity","Гравітація","Гравитация")
L("OPT_HUD","HUD","HUD","HUD")
L("OPT_CUSTOMFOV","Custom FOV","Власний FOV","Свой FOV")
L("OPT_CAMERAFOV","Camera FOV","FOV камери","FOV камеры")
L("OPT_HOLDZOOM","Hold Zoom","Утримувати зум","Удерживать зум")
L("OPT_ZOOMFOV","Zoom FOV","FOV зуму","FOV зума")
L("OPT_FREECAM","Freecam","Вільна камера","Свободная камера")
L("OPT_FREECAMSPEED","Freecam Speed","Швидкість камери","Скорость камеры")
L("OPT_ZOOMLIMIT","Zoom Out Limit","Ліміт віддалення","Лимит отдаления")
L("OPT_MAXZOOM","Max Zoom Distance","Макс. дистанція зуму","Макс. дистанция зума")
L("OPT_SNOW","Snow","Сніг","Снег")
L("OPT_SNOWDENSITY","Snow Density","Густота снігу","Плотность снега")
L("OPT_RAIN","Rain","Дощ","Дождь")
L("OPT_RAINDENSITY","Rain Density","Густота дощу","Плотность дождя")
L("OPT_WIND","Wind","Вітер","Ветер")
L("OPT_FOG","Fog","Туман","Туман")
L("OPT_FOGDIST","Fog Distance","Дистанція туману","Дистанция тумана")
L("OPT_FOGCOLOR","Fog Color","Колір туману","Цвет тумана")
L("OPT_LIGHTNING","Lightning","Блискавка","Молния")
L("OPT_LIGHTNINGINT","Lightning Interval","Інтервал блискавки","Интервал молнии")
L("OPT_ATMOSPHERE","Atmosphere","Атмосфера","Атмосфера")
L("OPT_ATMODENSITY","Atmo Density","Густота атмосфери","Плотность атмосферы")
L("OPT_ATMOHAZE","Atmo Haze","Серпанок","Дымка")
L("OPT_ATMOCOLOR","Atmo Color","Колір атмосфери","Цвет атмосферы")
L("OPT_SUNRAYS","Sun Rays","Промені сонця","Лучи солнца")
L("OPT_RAYSINT","Rays Intensity","Інтенсивність променів","Интенсивность лучей")
L("OPT_RAYSSPREAD","Rays Spread","Розсіювання променів","Рассеивание лучей")
L("OPT_RAINBOW","Rainbow World","Веселковий світ","Радужный мир")
L("OPT_RAINBOWSPEED","Rainbow Speed","Швидкість веселки","Скорость радуги")
L("OPT_FORCETIME","Force Time Of Day","Фіксувати час доби","Зафиксировать время суток")
L("OPT_TIMEOFDAY","Time Of Day","Час доби","Время суток")
L("OPT_TIMEFLOW","Time Flow","Плин часу","Течение времени")
L("OPT_FLOWSPEED","Flow Speed","Швидкість плину","Скорость течения")
L("OPT_GLOW","Glow / Bloom","Світіння / Блум","Свечение / Блум")
L("OPT_GLOWINT","Glow Intensity","Інтенсивність світіння","Интенсивность свечения")
L("OPT_GLOWSIZE","Glow Size","Розмір світіння","Размер свечения")
L("OPT_COLORGRADE","Color Grading","Кольорокорекція","Цветокоррекция")
L("OPT_SATURATION","Saturation","Насиченість","Насыщенность")
L("OPT_CONTRAST","Contrast","Контраст","Контраст")
L("OPT_BRIGHTNESS","Brightness","Яскравість","Яркость")
L("OPT_TINT","Tint","Відтінок","Оттенок")
L("OPT_VISIONMODE","Vision Mode","Режим зору","Режим зрения")
L("OPT_DOF","Depth Of Field","Глибина різкості","Глубина резкости")
L("OPT_FOCUSDIST","Focus Distance","Дистанція фокусу","Дистанция фокуса")
L("OPT_BLURAMOUNT","Blur Amount","Сила розмиття","Сила размытия")
L("OPT_NEARBLUR","Near Blur","Розмиття зблизька","Размытие вблизи")
L("OPT_FOCUSRADIUS","Focus Radius","Радіус фокусу","Радиус фокуса")
L("OPT_SCREENBLUR","Screen Blur","Розмиття екрану","Размытие экрана")
L("SEC_AMBIENT","AMBIENT LIGHT","ОТОЧЕННЯ","ОКРУЖЕНИЕ")
L("OPT_AMBIENT","Ambient Override","Перекрити оточення","Переопределить окружение")
L("OPT_AMBIENTCOLOR","Ambient Color","Колір оточення","Цвет окружения")
L("OPT_AMBIENTINT","Ambient Intensity","Інтенсивність оточення","Интенсивность окружения")
L("SEC_SKY","SKY","НЕБО","НЕБО")
L("OPT_STARS","Stars","Зірки","Звёзды")
L("OPT_STARCOUNT","Star Count","Кількість зірок","Количество звёзд")
L("SEC_PARTICLES","PARTICLES","ЧАСТИНКИ","ЧАСТИЦЫ")
L("OPT_ASH","Ash / Embers","Попіл / Іскри","Пепел / Искры")
L("OPT_ASHINT","Ash Density","Густота попелу","Плотность пепла")
L("OPT_BLURSIZE","Blur Size","Розмір розмиття","Размер размытия")
L("OPT_VIGNETTE","Vignette","Віньєтка","Виньетка")
L("OPT_VIGNETTEINT","Vignette Strength","Сила віньєтки","Сила виньетки")
L("OPT_CUSTOMCROSS","Custom Crosshair","Власний приціл","Свой прицел")
L("OPT_CROSSSIZE","Crosshair Size","Розмір прицілу","Размер прицела")
L("OPT_CROSSGAP","Crosshair Gap","Проміжок прицілу","Промежуток прицела")
L("OPT_CROSSTHICK","Crosshair Thickness","Товщина прицілу","Толщина прицела")
L("OPT_CENTERDOT","Center Dot","Центральна точка","Центральная точка")
L("OPT_CROSSCOLOR","Crosshair Color","Колір прицілу","Цвет прицела")
L("OPT_SPIN","Spin","Обертання","Вращение")
L("OPT_DYNAMICGAP","Dynamic Gap","Динамічний проміжок","Динамический промежуток")
L("OPT_REDONTARGET","Turn Red On Target","Червоний по цілі","Красный по цели")
L("OPT_HITMARKER","Hit Marker","Маркер попадання","Маркер попадания")
L("OPT_HITSOUND","Hit Sound","Звук попадання","Звук попадания")
L("OPT_HITSTYLE","Hit Marker Style","Стиль маркера","Стиль маркера")
L("OPT_HITEFFECT","Hit Effect","Ефект попадання","Эффект попадания")
L("OPT_HITSIZE","Hit Marker Size","Розмір маркера","Размер маркера")
L("OPT_HITTIME","Hit Marker Time","Час маркера","Время маркера")
L("OPT_THEME","Theme","Тема","Тема")
L("OPT_ACCENT","Accent","Акцент","Акцент")
L("OPT_MENUSCALE","Menu Scale","Масштаб меню","Масштаб меню")
L("OPT_MENUTRANSP","Menu Transparency","Прозорість меню","Прозрачность меню")
L("OPT_LANGUAGE","Language","Мова","Язык")
L("LBL_USERNAME","Username","Ім'я користувача","Имя пользователя")
L("LBL_USERID","User ID","ID користувача","ID пользователя")
L("LBL_DISPLAYNAME","Display Name","Відображуване ім'я","Отображаемое имя")
L("LBL_ACCOUNTAGE","Account Age","Вік акаунту","Возраст аккаунта")
L("LBL_SESSIONTIME","Session Time","Час сесії","Время сессии")
L("LBL_PLACEID","Place ID","ID місця","ID места")
L("LBL_JOBID","Job ID","ID сервера","ID сервера")
L("LBL_PLAYERCOUNT","Players In Server","Гравців на сервері","Игроков на сервере")
L("LBL_PING","Ping","Пінг","Пинг")
L("LBL_FPS","FPS","ФПС","ФПС")
L("LBL_TEAM","Team","Команда","Команда")
L("LBL_HEALTH","Health","Здоров'я","Здоровье")
L("LBL_CHARSTATE","Character State","Стан персонажа","Состояние персонажа")
L("LBL_ALIVE","Alive","Живий","Жив")
L("LBL_DEAD","Dead","Мертвий","Мёртв")
L("LBL_NOCHAR","No Character","Немає персонажа","Нет персонажа")
L("LBL_NOTEAM","None","Немає","Нет")
L("LBL_DAYS","days","днів","дней")
L("LBL_CONFIGNAME","Config name","Назва конфігу","Название конфига")
L("LBL_CONFIGSTRING","Config string (copy / paste)","Рядок конфігу (копіювати / вставити)","Строка конфига (копировать / вставить)")
L("LBL_SAVEDCONFIGS","Saved configs","Збережені конфіги","Сохранённые конфиги")
L("LBL_CONFIGPREVIEW","Preview (typed name)","Перегляд (введена назва)","Предпросмотр (введённое имя)")
L("LBL_ON","ON","УВІМК","ВКЛ")
L("LBL_OFF","OFF","ВИМК","ВЫКЛ")
L("PH_CONFIGNAME","e.g. legit, rage, retail","напр. legit, rage, retail","напр. legit, rage, retail")
L("PH_CONFIGSTRING","Paste config here, or press Export","Вставте конфіг сюди, або натисніть Експорт","Вставьте конфиг сюда, или нажмите Экспорт")
L("BTN_EXPORT","EXPORT CONFIG","ЕКСПОРТ КОНФІГУ","ЭКСПОРТ КОНФИГА")
L("BTN_IMPORT","IMPORT CONFIG","ІМПОРТ КОНФІГУ","ИМПОРТ КОНФИГА")
L("BTN_SAVE","SAVE TO FILE","ЗБЕРЕГТИ У ФАЙЛ","СОХРАНИТЬ В ФАЙЛ")
L("BTN_LOAD","LOAD FROM FILE","ЗАВАНТАЖИТИ З ФАЙЛУ","ЗАГРУЗИТЬ ИЗ ФАЙЛА")
L("BTN_REFRESH","REFRESH LIST","ОНОВИТИ СПИСОК","ОБНОВИТЬ СПИСОК")
L("BTN_REFRESHLOG","REFRESH LOG","ОНОВИТИ ЛОГ","ОБНОВИТЬ ЛОГ")
L("BTN_CLEARLOG","CLEAR LOG","ОЧИСТИТИ ЛОГ","ОЧИСТИТЬ ЛОГ")
L("BTN_RESET","RESET TO DEFAULTS","СКИНУТИ ДО ЗАМОВЧУВАННЯ","СБРОСИТЬ ПО УМОЛЧАНИЮ")
L("BTN_UNLOAD","UNLOAD SCRIPT","ВИВАНТАЖИТИ СКРИПТ","ВЫГРУЗИТЬ СКРИПТ")
L("BTN_RESETCOLORS","RESET COLORS","СКИНУТИ КОЛЬОРИ","СБРОСИТЬ ЦВЕТА")
L("TOAST_LOADED","Vortex loaded","Vortex завантажено","Vortex загружен")
L("TOAST_PRESET","Preset: %s","Пресет: %s","Пресет: %s")
L("TOAST_EXPORTED","Config exported","Конфіг експортовано","Конфиг экспортирован")
L("TOAST_IMPORTED","Config imported (%d values)","Конфіг імпортовано (%d значень)","Конфиг импортирован (%d значений)")
L("TOAST_IMPORTFAIL","Import failed or empty","Помилка імпорту або пусто","Ошибка импорта или пусто")
L("TOAST_DEFAULTS","Defaults restored","Замовчування відновлено","Настройки по умолчанию восстановлены")
L("TOAST_SAVED","Saved to VortexCheats/%s.cfg","Збережено у VortexCheats/%s.cfg","Сохранено в VortexCheats/%s.cfg")
L("TOAST_SAVEFAIL","Save failed, check name","Помилка збереження, перевірте назву","Ошибка сохранения, проверьте имя")
L("TOAST_LOADED_FILE","Loaded %s (%d values)","Завантажено %s (%d значень)","Загружено %s (%d значений)")
L("TOAST_LOADFAIL","File not found","Файл не знайдено","Файл не найден")
L("TOAST_LANGSET","Language set: %s","Мову встановлено: %s","Язык установлен: %s")
L("TOAST_NOFOLDER","No saved configs yet","Ще немає збережених конфігів","Пока нет сохранённых конфигов")
L("TOAST_NOMOUSE","Mouse API unavailable, using Tool click","Mouse API недоступний, клік інструментом","Mouse API недоступен, клик инструментом")
L("TOAST_LOGREFRESH","Log report refreshed","Звіт логів оновлено","Отчёт логов обновлён")
L("TOAST_SEEDED","Built-in configs installed: rage, legit","Вбудовані конфіги встановлено: rage, legit","Встроенные конфиги установлены: rage, legit")
L("BIND_ZOOM","Zoom (hold)","Зум (утримувати)","Зум (удержание)")

function Locale.T(key)
	local set = Locale.Strings[Locale.Current]
	return (set and set[key]) or Locale.Strings.EN[key] or key
end
function Locale.Bind(inst, key, prop)
	prop = prop or "Text"
	table.insert(Locale.Registry, {Instance = inst, Key = key, Property = prop})
	inst[prop] = Locale.T(key)
end
function Locale.OnChange(cb) table.insert(Locale.Listeners, cb) end
function Locale.SetImmediate(code)
	if not Locale.Strings[code] then return false end
	Locale.Current = code
	for i = #Locale.Registry, 1, -1 do
		local e = Locale.Registry[i]
		if e.Instance.Parent == nil then table.remove(Locale.Registry, i) else e.Instance[e.Property] = Locale.T(e.Key) end
	end
	for _, cb in ipairs(Locale.Listeners) do task.spawn(cb) end
	return true
end
function Locale.SetLanguage(code, notify)
	if not Locale.SetImmediate(code) then return false end
	if notify then notify(string.format(Locale.T("TOAST_LANGSET"), code)) end
	return true
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera
while not Camera do task.wait(); Camera = Workspace.CurrentCamera end
for _, name in ipairs({"VortexAuth", "VortexOverlay", "VortexMenu", "VortexThemePick", "VortexMenuPick"}) do
	local old = PlayerGui:FindFirstChild(name)
	if old then old:Destroy() end
end

local ThemeKeys = {"Background", "Secondary", "Row", "Border", "Text", "SubText", "Muted", "Accent"}
local function Pal(...)
	local a, t = {...}, {}
	for i, k in ipairs(ThemeKeys) do t[k] = Color3.fromRGB(table.unpack(a[i])) end
	return t
end
local Themes = {
	Obsidian = Pal({9,9,12},{14,14,18},{22,22,28},{42,42,52},{238,238,244},{150,150,164},{92,92,106},{150,110,255}),
	Crimson = Pal({11,8,9},{17,12,13},{26,19,21},{52,38,41},{244,238,239},{164,150,152},{106,92,94},{255,82,96}),
	Ocean = Pal({7,11,15},{11,17,23},{17,25,33},{34,48,62},{232,240,246},{140,156,170},{84,100,114},{70,190,255}),
	Mono = Pal({10,10,10},{16,16,16},{24,24,24},{46,46,46},{240,240,240},{154,154,154},{96,96,96},{230,230,230}),
	Custom = Pal({9,9,12},{14,14,18},{22,22,28},{42,42,52},{238,238,244},{150,150,164},{92,92,106},{150,110,255}),
}
local ThemeNames = {"Obsidian", "Crimson", "Ocean", "Mono", "Custom"}
local AccentNames = {"Theme", "Violet", "Cyan", "Rose", "Emerald", "Amber", "White"}
local AccentColors = {
	Violet = Color3.fromRGB(150,110,255), Cyan = Color3.fromRGB(70,210,255), Rose = Color3.fromRGB(255,96,150),
	Emerald = Color3.fromRGB(70,225,140), Amber = Color3.fromRGB(255,190,70), White = Color3.fromRGB(240,240,240),
}
local SkinThemes = {Classic = {"Obsidian", "Theme"}, Windows = {"Crimson", "Theme"}, Dock = {"Ocean", "Theme"}, Terminal = {"Mono", "Emerald"},
	Notch = {"Obsidian", "Cyan"}, HUDStrip = {"Crimson", "Rose"}, Radial = {"Ocean", "Theme"}}

local Prefs = {Theme = "Obsidian", Accent = "Theme"}
local Theme, Bound, Refreshers = {}, {}, {}

local function Tween(o, props, dur, style, dir)
	local t = TweenService:Create(o, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function ApplyTheme()
	for k, v in pairs(Themes[Prefs.Theme]) do Theme[k] = v end
	local ov = AccentColors[Prefs.Accent]
	if ov then Theme.Accent = ov end
	for i = #Bound, 1, -1 do
		local e = Bound[i]
		if e[1].Parent == nil then table.remove(Bound, i) else Tween(e[1], {[e[2]] = Theme[e[3]]}, 0.3) end
	end
	for _, fn in ipairs(Refreshers) do pcall(fn) end
end
ApplyTheme()

local function New(class, parent, props)
	local o = Instance.new(class)
	for p, v in pairs(props or {}) do
		if type(v) == "string" and string.find(p, "Color") and string.sub(v, 1, 1) == "@" then
			local key = string.sub(v, 2)
			table.insert(Bound, {o, p, key})
			o[p] = Theme[key]
		else
			o[p] = v
		end
	end
	o.Parent = parent
	return o
end

local function Round(o, r)
	local full = r >= 100
	New("UICorner", o, {CornerRadius = UDim.new(full and 1 or 0, full and 0 or r)})
	return o
end

local function GlowStroke(parent)
	local stroke = New("UIStroke", parent, {Thickness = 1.5, Color = Color3.new(1,1,1), ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
	local grad = New("UIGradient", stroke, {})
	local function Paint()
		grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(0.5, Theme.Border), ColorSequenceKeypoint.new(1, Theme.Accent)})
	end
	Paint()
	table.insert(Refreshers, Paint)
	local spin = TweenService:Create(grad, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Rotation = 360})
	spin:Play()
	return spin
end

local KeyConfig = {AllowedUsers = {["KickVortex777"] = "g", ["KickVortex"] = "g"}}
local function Authorize(input)
	local personal = KeyConfig.AllowedUsers[LocalPlayer.Name]
	if personal == nil then return false, "This account is not authorized" end
	if input == personal then return true end
	return false, "Invalid key"
end

local CONFIG_FOLDER = "VortexCheats"
local function EnsureFolder()
	return (pcall(function() if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end end))
end
local function SanitizeFileName(name)
	name = string.gsub(name, "[^%w_ %-]", "")
	name = string.match(name, "^%s*(.-)%s*$")
	if name == "" then return nil end
	return name
end
local function ListConfigs()
	local names = {}
	pcall(function()
		if isfolder(CONFIG_FOLDER) then
			for _, path in ipairs(listfiles(CONFIG_FOLDER)) do
				local f = string.match(path, "([^\\/]+)%.cfg$")
				if f then table.insert(names, f) end
			end
		end
	end)
	table.sort(names)
	return names
end

local STATE_FOLDER = CONFIG_FOLDER .. "/state"
local function EnsureStateFolder()
	return (pcall(function()
		if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
		if not isfolder(STATE_FOLDER) then makefolder(STATE_FOLDER) end
	end))
end
local function SaveSetting(name, value)
	local safe = SanitizeFileName(name)
	if not safe then return false end
	if not EnsureStateFolder() then return false end
	return (pcall(function() writefile(STATE_FOLDER .. "/" .. safe .. ".txt", tostring(value)) end))
end
local function LoadSetting(name, default)
	local safe = SanitizeFileName(name)
	if not safe then return default end
	local path = STATE_FOLDER .. "/" .. safe .. ".txt"
	local ok, content = pcall(function()
		if not isfile(path) then error("missing") end
		return readfile(path)
	end)
	if not ok then return default end
	return content
end

local BuiltinConfigs = {
	rage = {
		AimbotEnabled = true, AimHold = false, AimTeamCheck = true, AimIgnoreBots = false, VisibleCheck = false, AimPart = "Head", AimSpeed = 45,
		FOVRadius = 260, MaxAimDistance = 2500, PredictionEnabled = true, PredictionTime = 0.16, ShowFOV = true, ShowTargetLine = true,
		TriggerEnabled = true, TriggerTeamCheck = true, TriggerIgnoreBots = false, TriggerWallCheck = false, TriggerFOV = 12, TriggerHitbox = true, TriggerPart = "Any",
		TriggerMaxDistance = 1500, TriggerDelay = 0, TriggerInterval = 0.03, TriggerHumanize = false, TriggerOnlyAim = false, ShowTriggerFOV = true,
		ESPEnabled = true, ESPTeamCheck = true, ESPIgnoreBots = false, ShowBoxes = true, ShowNames = true, ShowDistance = true, ShowHealth = true, ShowSkeleton = false,
		ShowHeadDot = true, ShowWeapon = true, ShowOffscreen = true, ChamsEnabled = true, ESPColor = "Red", ESPMaxDistance = 4000, ShowTracers = true,
		SpeedEnabled = false, FlyEnabled = false, NoclipEnabled = false, InfJumpEnabled = false,
		CrosshairEnabled = true, CrosshairSize = 6, CrosshairGap = 2, CrosshairThickness = 2, CrosshairDot = true, CrosshairColorName = "Red",
		CrosshairReactive = true, HitMarkerEnabled = true, HitSoundEnabled = true, HitMarkerStyle = "Cross", HitEffect = "Pulse", HitMarkerSize = 1.0, HitMarkerLifetime = 0.45,
	},
	legit = {
		AimbotEnabled = true, AimHold = true, AimTeamCheck = true, AimIgnoreBots = false, VisibleCheck = true, AimPart = "Head", AimSpeed = 9,
		FOVRadius = 70, MaxAimDistance = 900, PredictionEnabled = true, PredictionTime = 0.08, ShowFOV = false, ShowTargetLine = false,
		TriggerEnabled = false, TriggerTeamCheck = true, TriggerIgnoreBots = false, TriggerWallCheck = true, TriggerFOV = 4, TriggerHitbox = false, TriggerPart = "Head",
		TriggerMaxDistance = 700, TriggerDelay = 0.12, TriggerInterval = 0.18, TriggerHumanize = true, TriggerOnlyAim = true, ShowTriggerFOV = false,
		ESPEnabled = true, ESPTeamCheck = true, ESPIgnoreBots = false, ShowBoxes = false, ShowNames = true, ShowDistance = true, ShowHealth = false, ShowSkeleton = false,
		ShowHeadDot = false, ShowWeapon = false, ShowOffscreen = false, ChamsEnabled = false, ESPColor = "White", ESPMaxDistance = 1500, ShowTracers = false,
		SpeedEnabled = false, FlyEnabled = false, NoclipEnabled = false, InfJumpEnabled = false,
		CrosshairEnabled = false, HitMarkerEnabled = false, HitSoundEnabled = false, HitMarkerStyle = "Cross", HitEffect = "Pulse", HitMarkerSize = 1.0, HitMarkerLifetime = 0.45,
	},
}
local function SerializeValueTable(vals)
	local parts = {}
	for k, v in pairs(vals) do
		local t = type(v)
		if t == "boolean" then table.insert(parts, k .. "=" .. (v and "1" or "0"))
		elseif t == "number" or t == "string" then table.insert(parts, k .. "=" .. tostring(v)) end
	end
	table.sort(parts)
	return table.concat(parts, ";") .. "||"
end
local function SeedBuiltinConfigs(log)
	if not EnsureFolder() then return end
	local seeded = false
	for name, vals in pairs(BuiltinConfigs) do
		local ok, exists = pcall(isfile, CONFIG_FOLDER .. "/" .. name .. ".cfg")
		if ok and not exists then
			local wrote = pcall(function() writefile(CONFIG_FOLDER .. "/" .. name .. ".cfg", SerializeValueTable(vals)) end)
			if wrote then
				seeded = true
				if log then log("config", "seeded built-in config: " .. name .. ".cfg") end
			elseif log then
				log("config", "failed to seed built-in config: " .. name, true)
			end
		end
	end
	return seeded
end

local DebugLog = {List = {}, Map = {}, Max = 300}
function DebugLog.Push(mod, text, isErr)
	local id = mod .. "|" .. text
	local e = DebugLog.Map[id]
	if e then e.Count += 1; e.Last = os.date("%H:%M:%S"); return end
	if #DebugLog.List >= DebugLog.Max then
		local old = table.remove(DebugLog.List, 1)
		DebugLog.Map[old.Id] = nil
	end
	e = {Id = id, Mod = mod, Text = text, First = os.date("%H:%M:%S"), Last = os.date("%H:%M:%S"), Count = 1, Err = isErr == true}
	DebugLog.Map[id] = e
	table.insert(DebugLog.List, e)
end
function DebugLog.Clear() table.clear(DebugLog.List); table.clear(DebugLog.Map) end
function DebugLog.Report()
	local out, errs = {}, 0
	for _, e in ipairs(DebugLog.List) do
		local line = string.format("[%s] %s - %s", e.First, e.Mod, e.Text)
		if e.Count > 1 then line ..= string.format("  (x%d, last %s)", e.Count, e.Last) end
		if e.Err then errs += 1 end
		table.insert(out, {text = line, err = e.Err})
	end
	return out, errs
end
local function Safe(mod, fn, ...)
	local ok, err = pcall(fn, ...)
	if not ok then DebugLog.Push(mod, tostring(err), true) end
end
DebugLog.Push("system", "boot sequence started")
DebugLog.Push("locale", "language table loaded: EN, UA, RU")
do
	local seeded = SeedBuiltinConfigs(DebugLog.Push)
	if seeded then DebugLog.Push("config", "built-in configs ready in " .. CONFIG_FOLDER) end
end

local function Fmt(v, d)
	if d == 0 then return tostring(math.floor(v + 0.5)) end
	return string.format("%." .. d .. "f", v)
end

local GOTH, GOTHB, GOTHM, CODE = Enum.Font.Gotham, Enum.Font.GothamBold, Enum.Font.GothamMedium, Enum.Font.Code
local LEFT, RIGHT, CENTER = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right, Enum.TextXAlignment.Center

local function LaunchHub(skinName)
	local pref = SkinThemes[skinName] or SkinThemes.Classic
	Prefs.Theme, Prefs.Accent = pref[1], pref[2]
	ApplyTheme()
	DebugLog.Push("system", "hub init, skin = " .. skinName .. ", theme = " .. Prefs.Theme)

	local S = {
		AimbotEnabled = false, AimHold = true, AimTeamCheck = true, AimIgnoreBots = false, VisibleCheck = true, AimPart = "Head", AimSpeed = 14,
		FOVRadius = 150, MaxAimDistance = 1500, PredictionEnabled = false, PredictionTime = 0.12, ShowFOV = true, ShowTargetLine = false,
		TriggerEnabled = false, TriggerTeamCheck = true, TriggerIgnoreBots = false, TriggerWallCheck = true, TriggerFOV = 5, TriggerHitbox = true, TriggerPart = "Any",
		TriggerMaxDistance = 1000, TriggerDelay = 0.05, TriggerInterval = 0.1, TriggerHumanize = true, TriggerOnlyAim = false,
		ShowTriggerFOV = true, TriggerClickMode = "Auto",
		ESPEnabled = false, ESPTeamCheck = true, ESPIgnoreBots = false, ShowBoxes = true, ShowNames = true, ShowDistance = true, ShowHealth = true,
		ShowSkeleton = true, ShowHeadDot = false, ShowWeapon = false, ShowOffscreen = false, ChamsEnabled = false, ESPColor = "Red",
		ESPMaxDistance = 3000, ShowTracers = false, TracerOrigin = "Bottom", CornerBoxEnabled = false,
		SpeedEnabled = false, SpeedValue = 32, JumpEnabled = false, JumpValue = 80, FlyEnabled = false, FlySpeed = 70,
		NoclipEnabled = false, InfJumpEnabled = false,
		FullBrightEnabled = false, NoShadowsEnabled = false, CustomFOVEnabled = false, CameraFOV = 90, ZoomEnabled = false, ZoomFOV = 25,
		FreecamEnabled = false, FreecamSpeed = 60, ZoomLimitEnabled = false, ZoomLimit = 120, HUDEnabled = false,
		ExposureEnabled = false, Exposure = 0, HideCloudsEnabled = false, GravityEnabled = false, GravityValue = 196,
		SnowEnabled = false, SnowIntensity = 40, RainEnabled = false, RainIntensity = 40, WindStrength = 4, FogEnabled = false,
		FogDensity = 200, FogColorName = "Theme", LightningEnabled = false, LightningInterval = 8,
		AtmosphereEnabled = false, AtmoDensity = 0.35, AtmoHaze = 2, AtmoColorName = "Theme", SunRaysEnabled = false,
		SunRaysIntensity = 0.25, SunRaysSpread = 0.6, RainbowEnabled = false, RainbowSpeed = 0.2,
		TimeOfDayEnabled = false, TimeOfDay = 14, TimeFlowEnabled = false, TimeFlowSpeed = 0.3,
		GlowEnabled = false, GlowIntensity = 0.4, GlowSize = 24, ColorGradeEnabled = false, ColorSaturation = 0, ColorContrast = 0, ColorBrightness = 0, ColorTintName = "None",
		VisionMode = "Off", DOFEnabled = false, DOFFocus = 60, DOFFar = 0.4, DOFNear = 0, DOFRadius = 40, BlurEnabled = false, BlurSize = 8,
		VignetteEnabled = false, VignetteIntensity = 0.5,
		AmbientEnabled = false, AmbientColorName = "Theme", AmbientIntensity = 0.5,
		StarsEnabled = false, StarCount = 3000,
		AshEnabled = false, AshIntensity = 30,
		CrosshairEnabled = false, CrosshairSize = 8, CrosshairGap = 4, CrosshairThickness = 2, CrosshairDot = true,
		CrosshairColorName = "Theme", CrosshairSpin = false, CrosshairDynamic = true, CrosshairReactive = true,
		HitMarkerEnabled = false, HitSoundEnabled = false, HitMarkerStyle = "Cross", HitEffect = "Pulse", HitMarkerSize = 1.0, HitMarkerLifetime = 0.45, WorldPreset = "None", UIScale = 1, UIOpacity = 0,
	}
	local Defaults = {}
	for k, v in pairs(S) do Defaults[k] = v end

	local K = {
		Menu = Enum.KeyCode.RightShift, AimbotEnabled = Enum.KeyCode.Q, TriggerEnabled = Enum.KeyCode.T, ESPEnabled = Enum.KeyCode.F2,
		FlyEnabled = Enum.KeyCode.F, SpeedEnabled = Enum.KeyCode.V, NoclipEnabled = Enum.KeyCode.Unknown,
		FreecamEnabled = Enum.KeyCode.P, HUDEnabled = Enum.KeyCode.H, Zoom = Enum.KeyCode.C,
	}
	local BindNameKeys = {AimbotEnabled = "OPT_AIMBOT", TriggerEnabled = "OPT_TRIGGERBOT", ESPEnabled = "OPT_ESP", FlyEnabled = "OPT_FLY",
		SpeedEnabled = "OPT_SPEED", NoclipEnabled = "OPT_NOCLIP", FreecamEnabled = "OPT_FREECAM", HUDEnabled = "OPT_HUD"}
	local BindOrder = {"AimbotEnabled", "TriggerEnabled", "ESPEnabled", "FlyEnabled", "SpeedEnabled", "NoclipEnabled", "FreecamEnabled", "HUDEnabled"}

	local ESPColors = {Red = Color3.fromRGB(255,70,80), Cyan = Color3.fromRGB(70,220,255), Green = Color3.fromRGB(90,235,130),
		Yellow = Color3.fromRGB(255,220,80), Pink = Color3.fromRGB(255,110,200), White = Color3.fromRGB(245,245,245)}
	local ESPColorNames = {"Red", "Cyan", "Green", "Yellow", "Pink", "White"}
	local CrosshairColorNames = {"Theme", "Red", "Cyan", "Green", "Yellow", "Pink", "White"}
	local TracerOriginNames = {"Bottom", "Top", "Center"}
local HitMarkerStyles = {"Cross", "X", "Plus", "Circle", "Diamond", "Star", "Brackets", "Dot", "Hit", "Skull", "Lightning"}
local HitEffects = {"None", "Pulse", "Explosion", "Lightning", "Pulse+Explosion", "Pulse+Lightning", "Explosion+Lightning", "All"}
	local WorldTintColors = {None = Color3.fromRGB(255,255,255), Blue = Color3.fromRGB(120,170,255), Orange = Color3.fromRGB(255,170,110),
		Green = Color3.fromRGB(140,255,170), Purple = Color3.fromRGB(190,140,255), Sepia = Color3.fromRGB(255,210,150)}
	local WorldTintNames = {"None", "Blue", "Orange", "Green", "Purple", "Sepia"}
	local FogColorNames = {"Theme", "Blue", "Orange", "Green", "Purple", "Sepia"}
	local LanguageCodes = {"EN", "RU", "UA"}
	local VisionPresets = {
		["Night Vision"] = {Saturation = -0.3, Contrast = 0.15, Brightness = 0.12, Tint = Color3.fromRGB(130,255,150)},
		Noir = {Saturation = -1, Contrast = 0.25, Brightness = 0, Tint = Color3.fromRGB(255,255,255)},
		Vintage = {Saturation = -0.35, Contrast = 0.1, Brightness = 0.02, Tint = Color3.fromRGB(255,225,180)},
		Neon = {Saturation = 0.9, Contrast = 0.25, Brightness = 0, Tint = Color3.fromRGB(255,210,255)},
	}
	local VisionNames = {"Off", "Night Vision", "Noir", "Vintage", "Neon"}
	local WorldKeys = {"SnowEnabled","SnowIntensity","RainEnabled","RainIntensity","WindStrength","FogEnabled","FogDensity","FogColorName",
		"LightningEnabled","LightningInterval","AtmosphereEnabled","AtmoDensity","AtmoHaze","AtmoColorName","SunRaysEnabled","SunRaysIntensity",
		"SunRaysSpread","RainbowEnabled","RainbowSpeed","TimeOfDayEnabled","TimeOfDay","TimeFlowEnabled","TimeFlowSpeed","GlowEnabled",
		"GlowIntensity","GlowSize","ColorGradeEnabled","ColorSaturation","ColorContrast","ColorBrightness","ColorTintName","VisionMode","DOFEnabled","DOFFocus","DOFFar","DOFNear","DOFRadius",
		"BlurEnabled","BlurSize","VignetteEnabled","VignetteIntensity","ExposureEnabled","Exposure","HideCloudsEnabled",
		"AmbientEnabled","AmbientColorName","AmbientIntensity","StarsEnabled","StarCount","AshEnabled","AshIntensity"}
	local Presets = {
		Thunderstorm = {RainEnabled = true, RainIntensity = 150, WindStrength = 10, FogEnabled = true, FogDensity = 350, FogColorName = "Blue",
			LightningEnabled = true, LightningInterval = 7, TimeOfDayEnabled = true, TimeOfDay = 20, VignetteEnabled = true, VignetteIntensity = 0.6,
			ColorGradeEnabled = true, ColorSaturation = -0.25, ColorTintName = "Blue"},
		Blizzard = {SnowEnabled = true, SnowIntensity = 140, WindStrength = 18, FogEnabled = true, FogDensity = 180, FogColorName = "Blue",
			ColorGradeEnabled = true, ColorSaturation = -0.35, ColorTintName = "Blue", VignetteEnabled = true, VignetteIntensity = 0.4},
		["Golden Hour"] = {TimeOfDayEnabled = true, TimeOfDay = 17.4, SunRaysEnabled = true, SunRaysIntensity = 0.35, GlowEnabled = true, GlowIntensity = 0.5,
			ColorGradeEnabled = true, ColorSaturation = 0.2, ColorTintName = "Orange", AtmosphereEnabled = true, AtmoDensity = 0.3, AtmoHaze = 1.5, AtmoColorName = "Orange"},
		["Cyber Night"] = {TimeOfDayEnabled = true, TimeOfDay = 0.5, GlowEnabled = true, GlowIntensity = 0.8, VisionMode = "Neon", RainbowEnabled = true,
			RainbowSpeed = 0.15, VignetteEnabled = true, VignetteIntensity = 0.5, AtmosphereEnabled = true, AtmoDensity = 0.4, AtmoHaze = 3, AtmoColorName = "Purple"},
		["Foggy Dawn"] = {TimeOfDayEnabled = true, TimeOfDay = 6.2, FogEnabled = true, FogDensity = 260, FogColorName = "Sepia", AtmosphereEnabled = true,
			AtmoDensity = 0.5, AtmoHaze = 4, AtmoColorName = "Sepia", SunRaysEnabled = true, SunRaysIntensity = 0.3, DOFEnabled = true, DOFFar = 0.25},
		["Clear Night"] = {TimeOfDayEnabled = true, TimeOfDay = 1.5, StarsEnabled = true, StarCount = 6000, AmbientEnabled = true, AmbientColorName = "Blue",
			AmbientIntensity = 0.25, VignetteEnabled = true, VignetteIntensity = 0.35},
		["Volcanic"] = {AshEnabled = true, AshIntensity = 50, TimeOfDayEnabled = true, TimeOfDay = 19, AtmosphereEnabled = true, AtmoDensity = 0.45,
			AtmoHaze = 5, AtmoColorName = "Orange", ColorGradeEnabled = true, ColorSaturation = 0.15, ColorContrast = 0.1, ColorTintName = "Orange",
			GlowEnabled = true, GlowIntensity = 0.4},
		["Faded Film"] = {ColorGradeEnabled = true, ColorSaturation = -0.5, ColorContrast = -0.15, ColorBrightness = 0.05, ColorTintName = "Sepia",
			VignetteEnabled = true, VignetteIntensity = 0.45, GlowEnabled = true, GlowIntensity = 0.2},
	}
	local PresetNames = {"None", "Clear", "Thunderstorm", "Blizzard", "Golden Hour", "Cyber Night", "Foggy Dawn", "Clear Night", "Volcanic", "Faded Film"}
	local R15Bones = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
		{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
		{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
	local R6Bones = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
	local R15Names = {"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg"}
	local R6Names = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}

	local Conns, Sync, Hooks, Entries, Widgets, Infos, OnBind = {}, {}, {}, {}, {}, {}, {}
local EntryOrder, EntryIndex = {}, {}
	local Unloaded, Listening, Skin = false, nil, nil
	local MenuState = {Open = false}
	local SessionStart = os.clock()
	local Drag = {}
	local Skins = {}

	local function Connect(sig, cb) local c = sig:Connect(cb); table.insert(Conns, c); return c end

	local function CollapseOnScroll(header, group, chevron)
		local collapsed = false
		local hovering = false
		local function Paint()
			group.Visible = not collapsed
			if chevron then Tween(chevron, {Rotation = collapsed and -90 or 0}, 0.15) end
		end
		Connect(header.MouseEnter, function() hovering = true end)
		Connect(header.MouseLeave, function() hovering = false end)
		Connect(UserInputService.InputChanged, function(input)
			if not hovering then return end
			if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
			local up = input.Position.Z > 0
			if up and not collapsed then collapsed = true; Paint()
			elseif (not up) and collapsed then collapsed = false; Paint() end
		end)
		return {IsCollapsed = function() return collapsed end}
	end

	local function SetValue(key, value)
		S[key] = value
		if Sync[key] then for _, fn in ipairs(Sync[key]) do fn() end end
		if Hooks[key] then Hooks[key](value) end
	end
	local function Watch(key, fn, themed)
		if key then Sync[key] = Sync[key] or {}; table.insert(Sync[key], fn) end
		if themed then table.insert(Refreshers, fn) end
		fn()
	end
	local function KeyName(code) return code == Enum.KeyCode.Unknown and "NONE" or code.Name end
	local function TintColor(name)
		if name == "Theme" then return Theme.Accent end
		return WorldTintColors[name] or Color3.fromRGB(255,255,255)
	end
	local function IsPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

	local Overlay = New("ScreenGui", PlayerGui, {Name = "VortexOverlay", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 5})
	local MenuGui = New("ScreenGui", PlayerGui, {Name = "VortexMenu", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10})

	local Toasts = New("Frame", Overlay, {AnchorPoint = Vector2.new(1,1), Position = UDim2.new(1,-16,1,-16), Size = UDim2.fromOffset(240,300), BackgroundTransparency = 1})
	New("UIListLayout", Toasts, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right})
	local function Notify(text)
		local toast = Round(New("CanvasGroup", Toasts, {Size = UDim2.fromOffset(230,34), BackgroundColor3 = "@Secondary", BorderSizePixel = 0, GroupTransparency = 1}), 8)
		New("UIStroke", toast, {Color = "@Border", Thickness = 1})
		New("Frame", toast, {Size = UDim2.fromOffset(3,18), Position = UDim2.fromOffset(8,8), BackgroundColor3 = "@Accent", BorderSizePixel = 0})
		New("TextLabel", toast, {Position = UDim2.fromOffset(20,0), Size = UDim2.new(1,-28,1,0), BackgroundTransparency = 1, Text = text, TextColor3 = "@Text",
			Font = GOTHM, TextSize = 12, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
		Tween(toast, {GroupTransparency = 0}, 0.25)
		task.delay(2.2, function()
			if toast.Parent then
				Tween(toast, {GroupTransparency = 1}, 0.3)
				task.delay(0.35, function() toast:Destroy() end)
			end
		end)
	end

	local Combat = {LastFire = 0}
	local Aim = {ScanAccum = 0, ScanInterval = 1 / 45}
	local Trigger = {LastScan = 0, EnterTime = nil, NextFire = 0, Player = nil, Part = nil, Target = nil, ScanInterval = 1 / 30, CenterAccum = 0}
	local Fly = {Active = false}
	local Noclip = {Parts = {}, Character = nil, BaseParts = {}, Next = 0}
	local Applied = {Speed = false, Jump = false}
	local World = {NextFlash = 0}
	local Hud = {Accum = 0, Frames = 0}
	local Freecam = {Active = false, Yaw = 0, Pitch = 0, Position = Vector3.zero}

	local AimParams = RaycastParams.new()
	AimParams.FilterType = Enum.RaycastFilterType.Exclude; AimParams.IgnoreWater = true; AimParams.RespectCanCollide = false
	local TriggerParams = RaycastParams.new()
	TriggerParams.FilterType = Enum.RaycastFilterType.Exclude; TriggerParams.IgnoreWater = true; TriggerParams.RespectCanCollide = false

	local function MoveDir(rot)
		local d = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then d += rot.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then d -= rot.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then d += rot.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then d -= rot.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then d -= Vector3.yAxis end
		return d
	end
	function Freecam.Start()
		Freecam.Active = true
		local cf = Camera.CFrame
		local pitch, yaw = cf:ToOrientation()
		Freecam.Pitch, Freecam.Yaw, Freecam.Position = pitch, yaw, cf.Position
		Freecam.PreviousType, Freecam.PreviousMouse = Camera.CameraType, UserInputService.MouseBehavior
		Camera.CameraType = Enum.CameraType.Scriptable
		ContextActionService:BindActionAtPriority("VortexFreecamSink", function() return Enum.ContextActionResult.Sink end, false,
			Enum.ContextActionPriority.High.Value, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftControl, Enum.KeyCode.LeftShift)
	end
	function Freecam.Stop()
		if not Freecam.Active then return end
		Freecam.Active = false
		ContextActionService:UnbindAction("VortexFreecamSink")
		UserInputService.MouseBehavior = Freecam.PreviousMouse or Enum.MouseBehavior.Default
		Camera.CameraType = Freecam.PreviousType or Enum.CameraType.Custom
	end
	function Freecam.Update(dt)
		if not S.FreecamEnabled then
			if Freecam.Active then Freecam.Stop() end
			return
		end
		if not Freecam.Active then Freecam.Start() end
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			local d = UserInputService:GetMouseDelta()
			Freecam.Yaw -= d.X * 0.0035
			Freecam.Pitch = math.clamp(Freecam.Pitch - d.Y * 0.0035, -1.55, 1.55)
		else
			UserInputService.MouseBehavior = Freecam.PreviousMouse or Enum.MouseBehavior.Default
		end
		local rot = CFrame.fromOrientation(Freecam.Pitch, Freecam.Yaw, 0)
		local dir = UserInputService:GetFocusedTextBox() and Vector3.zero or MoveDir(rot)
		local speed = S.FreecamSpeed * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 3 or 1)
		if dir.Magnitude > 0 then dir = dir.Unit end
		Freecam.Position += dir * speed * dt
		Camera.CFrame = CFrame.new(Freecam.Position) * rot
	end

	local function IsEnemy(player, teamCheck)
		if player == LocalPlayer then return false end
		if teamCheck and player.Team ~= nil and player.Team == LocalPlayer.Team then return false end
		return true
	end
	local function EntryIsTargetable(entity, e, teamCheck, ignoreBots)
		if e and e.IsBot then
			return not ignoreBots
		end
		return entity ~= nil and IsEnemy(entity, teamCheck)
	end
	local function PartOf(e, name)
		local p = e.Parts[name]
		if p and p.Parent == e.Character then return p end
		p = e.Character and e.Character:FindFirstChild(name) or nil
		e.Parts[name] = p
		return p
	end
	local function IsVisible(part, character, params)
		local o = Camera.CFrame.Position
		local r = Workspace:Raycast(o, part.Position - o, params)
		return r == nil or r.Instance:IsDescendantOf(character)
	end
	local function GetAimPart(e)
		if S.AimPart == "Head" then return PartOf(e, "Head") or e.Root
		elseif S.AimPart == "Chest" then return PartOf(e, "UpperTorso") or PartOf(e, "Torso") or e.Root end
		return e.Root
	end
	local function Predict(part)
		if S.PredictionEnabled then return part.Position + part.AssemblyLinearVelocity * S.PredictionTime end
		return part.Position
	end
	local function FindTarget()
		local bestPart, bestPos, bestPlayer, best = nil, nil, nil, math.huge
		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local camPos = Camera.CFrame.Position
		local lc = LocalPlayer.Character
		AimParams.FilterDescendantsInstances = lc and {lc} or {}
		local entryCount = #EntryOrder
		for i = 1, entryCount do
			local entity = EntryOrder[i]
			local e = Entries[entity]
			if e and EntryIsTargetable(entity, e, S.AimTeamCheck, S.AimIgnoreBots) and e.Refresh() then
				local part = GetAimPart(e)
				if part then
					local pos = Predict(part)
					local delta = pos - camPos
					if delta:Dot(delta) <= S.MaxAimDistance * S.MaxAimDistance then
						local sc, on = Camera:WorldToViewportPoint(pos)
						if on then
							local dx, dy = sc.X - center.X, sc.Y - center.Y
							local d2 = dx * dx + dy * dy
							if d2 <= S.FOVRadius * S.FOVRadius and d2 < best * best and (not S.VisibleCheck or IsVisible(part, e.Character, AimParams)) then
								best = math.sqrt(d2)
								bestPart, bestPos, bestPlayer = part, pos, entity
							end
						end
					end
				end
			end
		end
		return bestPart, bestPos, bestPlayer
	end
	function Aim.Update(dt)
		if not S.AimbotEnabled or Freecam.Active then
			Aim.Part, Aim.Position, Aim.Player = nil, nil, nil
			Aim.ScanAccum = 0
			return
		end
		Aim.ScanAccum = (Aim.ScanAccum or 0) + dt
		if Aim.Part == nil or Aim.ScanAccum >= (Aim.ScanInterval or (1 / 75)) then
			Aim.ScanAccum = 0
			Aim.Part, Aim.Position, Aim.Player = FindTarget()
		end
		local part, pos = Aim.Part, Aim.Position
		if not part or not pos or part.Parent == nil then
			Aim.Part, Aim.Position, Aim.Player = nil, nil, nil
			return
		end
		if S.AimHold and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
		local cur = Camera.CFrame
		if (pos - cur.Position).Magnitude < 0.01 then return end
		Camera.CFrame = cur:Lerp(CFrame.lookAt(cur.Position, pos), 1 - math.exp(-S.AimSpeed * dt))
	end

	local TriggerPartNames = {
		R15 = {"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftUpperLeg","RightUpperLeg"},
		R6 = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"},
	}
	local function CollectTriggerParts(e)
		local mode = S.TriggerPart
		if e.TriggerMode == mode and e.TriggerCharacter == e.Character and e.TriggerParts and #e.TriggerParts > 0 then
			return e.TriggerParts
		end
		e.TriggerParts = e.TriggerParts or {}
		table.clear(e.TriggerParts)
		e.TriggerMode, e.TriggerCharacter = mode, e.Character
		if mode == "Head" then
			local h = PartOf(e, "Head")
			if h then e.TriggerParts[1] = h end
		elseif mode == "Body" then
			local torso = PartOf(e, e.Humanoid.RigType == Enum.HumanoidRigType.R15 and "UpperTorso" or "Torso")
			if torso then e.TriggerParts[#e.TriggerParts + 1] = torso end
			if e.Root and e.Root ~= torso then e.TriggerParts[#e.TriggerParts + 1] = e.Root end
		else
			local names = e.Humanoid.RigType == Enum.HumanoidRigType.R15 and TriggerPartNames.R15 or TriggerPartNames.R6
			for _, n in ipairs(names) do
				local p = PartOf(e, n)
				if p then e.TriggerParts[#e.TriggerParts + 1] = p end
			end
		end
		return e.TriggerParts
	end

	local VIM, MouseApiFailed = nil, false
	local TriggerRayScratch = {}

	local function ResetTriggerState()
		Trigger.Player, Trigger.Part, Trigger.Target = nil, nil, nil
		Trigger.EnterTime, Trigger.NextFire = nil, 0
	end

	local function FireTrigger()
		if MenuState.Open or UserInputService:GetFocusedTextBox() then return false end

		if S.TriggerClickMode == "Tool" then
			local ch = LocalPlayer.Character
			local tool = ch and ch:FindFirstChildOfClass("Tool")
			if tool and tool.Enabled then
				local ok = pcall(function() tool:Activate() end)
				return ok
			end
			return false
		end

		if type(mouse1click) == "function" then
			local ok = pcall(mouse1click)
			if ok then return true end
		end

		if not MouseApiFailed then
			local ok = pcall(function()
				VIM = VIM or game:GetService("VirtualInputManager")
				local p = UserInputService:GetMouseLocation()
				if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
					p = Camera.ViewportSize / 2
				end
				VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 0)
				VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 0)
			end)
			if ok then return true end
			MouseApiFailed = true
			Notify(Locale.T("TOAST_NOMOUSE"))
			DebugLog.Push("triggerbot", "mouse input unavailable; using Tool fallback")
		end

		local ch = LocalPlayer.Character
		local tool = ch and ch:FindFirstChildOfClass("Tool")
		if tool and tool.Enabled then
			local ok = pcall(function() tool:Activate() end)
			if ok then return true end
		end
		return false
	end

	local function ResolveEntityFromHit(inst)
		if not inst then return nil, nil, nil end
		local current = inst
		for _ = 1, 12 do
			if not current or current == Workspace then break end
			local entity = nil
			local e = Entries[current]
			if e then
				return current, e, inst:IsA("BasePart") and inst or nil
			end
			local player = Players:GetPlayerFromCharacter(current)
			if player and Entries[player] then
				return player, Entries[player], inst:IsA("BasePart") and inst or nil
			end
			current = current.Parent
		end

		return nil, nil, nil
	end

	local function CenterRayTarget()
		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local ray = Camera:ViewportPointToRay(center.X, center.Y)
		local maxDist = math.max(S.TriggerMaxDistance, 1)
		local hit = Workspace:Raycast(ray.Origin, ray.Direction * maxDist, TriggerParams)
		if not hit then return nil, nil, nil end

		local entity, e, hitPart = ResolveEntityFromHit(hit.Instance)
		if not entity or not e or not e.Refresh() or not EntryIsTargetable(entity, e, S.TriggerTeamCheck, S.TriggerIgnoreBots) then
			return nil, nil, nil
		end

		local part = hitPart
		if not part or not part:IsA("BasePart") or not part:IsDescendantOf(e.Character) then
			part = PartOf(e, "Head") or e.Root
		end
		return entity, part, e
	end

	local TriggerScanRuntime = {Cursor = 1}
	local function FindTriggerTarget()
		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local tanHalf = math.tan(math.rad(Camera.FieldOfView) * 0.5)
		local ppS = tanHalf > 0.0001 and (vp.Y / (2 * tanHalf)) or 1
		local camPos = Camera.CFrame.Position
		local maxDistSq = S.TriggerMaxDistance * S.TriggerMaxDistance
		TriggerParams.FilterDescendantsInstances = (LocalPlayer.Character and {LocalPlayer.Character}) or {}

		local hitEntity, hitPart, hitEntry = CenterRayTarget()
		if hitEntity and hitPart then
			return hitEntity, hitPart, hitEntry
		end

		local now = os.clock()
		if now - (Trigger.LastScan or 0) < (Trigger.ScanInterval or (1 / 45)) then
			return nil, nil, nil
		end
		Trigger.LastScan = now

		local candidates = {}
		local function addCandidate(entity, e, part, screenDistSq, worldDistSq)
			local candidate = {Entity = entity, Entry = e, Part = part, Distance = screenDistSq, WorldDistanceSq = worldDistSq}
			if #candidates < 6 then
				candidates[#candidates + 1] = candidate
				return
			end
			local worst = 1
			for i = 2, #candidates do
				if candidates[i].Distance > candidates[worst].Distance then worst = i end
			end
			if screenDistSq < candidates[worst].Distance then
				candidates[worst] = candidate
			end
		end

		local count = #EntryOrder
		if count > 0 then
			local work = count >= 45 and 24 or count
			if work > count then work = count end
			for _ = 1, work do
				if TriggerScanRuntime.Cursor > count then TriggerScanRuntime.Cursor = 1 end
				local entity = EntryOrder[TriggerScanRuntime.Cursor]
				TriggerScanRuntime.Cursor += 1
				local e = entity and Entries[entity]
				if e and EntryIsTargetable(entity, e, S.TriggerTeamCheck, S.TriggerIgnoreBots) and e.Refresh() then
					local root = e.Root
					if root and root.Parent then
						local rootDelta = root.Position - camPos
						local rootDistSq = rootDelta:Dot(rootDelta)
						if rootDistSq <= maxDistSq then
							local parts = CollectTriggerParts(e)
							for i = 1, #parts do
								local part = parts[i]
								if part and part.Parent then
									local delta = part.Position - camPos
									local distSq = delta:Dot(delta)
									if distSq <= maxDistSq then
										local sc = Camera:WorldToViewportPoint(part.Position)
										if sc.Z > 0 then
											local reach = S.TriggerFOV
											if S.TriggerHitbox then
												reach += math.max(part.Size.X, part.Size.Y) * 0.5 * ppS / math.max(sc.Z, 1)
											end
											local dx, dy = sc.X - center.X, sc.Y - center.Y
											local screenDistSq = dx * dx + dy * dy
											if screenDistSq <= reach * reach then
												addCandidate(entity, e, part, screenDistSq, distSq)
												if screenDistSq <= 0.01 then break end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		table.sort(candidates, function(a, b)
			if a.Distance == b.Distance then return a.WorldDistanceSq < b.WorldDistanceSq end
			return a.Distance < b.Distance
		end)

		for i = 1, #candidates do
			local c = candidates[i]
			local e = c.Entry
			if e and e.Refresh() and c.Part and c.Part.Parent then
				if not S.TriggerWallCheck or IsVisible(c.Part, e.Character, TriggerParams) then
					return c.Entity, c.Part, e
				end
			end
		end
		return nil, nil, nil
	end

	local function TriggerTargetStillValid(entity, part, e)
		if not entity or not part or not e or Entries[entity] ~= e or not e.Refresh() then return false end
		if not EntryIsTargetable(entity, e, S.TriggerTeamCheck, S.TriggerIgnoreBots) then return false end
		local maxDist = math.max(S.TriggerMaxDistance, 1)
		local delta = part.Position - Camera.CFrame.Position
		if delta:Dot(delta) > maxDist * maxDist then return false end

		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local sc = Camera:WorldToViewportPoint(part.Position)
		if sc.Z <= 0 then return false end
		local dx, dy = sc.X - center.X, sc.Y - center.Y
		local reach = S.TriggerFOV
		if S.TriggerHitbox then
			local tanHalf = math.tan(math.rad(Camera.FieldOfView) * 0.5)
			local ppS = tanHalf > 0.0001 and (vp.Y / (2 * tanHalf)) or 1
			reach += math.max(part.Size.X, part.Size.Y) * 0.5 * ppS / math.max(sc.Z, 1)
		end
		if dx * dx + dy * dy > reach * reach then return false end

		if S.TriggerWallCheck then
			TriggerParams.FilterDescendantsInstances = (LocalPlayer.Character and {LocalPlayer.Character}) or {}
			if not IsVisible(part, e.Character, TriggerParams) then return false end
		end
		return true
	end

	function Trigger.Update()
		if not S.TriggerEnabled or Freecam.Active or MenuState.Open or UserInputService:GetFocusedTextBox() then
			ResetTriggerState()
			return
		end
		if S.TriggerOnlyAim and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			ResetTriggerState()
			return
		end

		local now = os.clock()
		local currentEntity, currentPart = Trigger.Player, Trigger.Part
		local currentEntry = Trigger.Target and Entries[Trigger.Target] or nil
		local lockedValid = currentEntity and currentPart and currentEntry and TriggerTargetStillValid(currentEntity, currentPart, currentEntry)

		if not lockedValid then
			local centerEntity, centerPart, centerEntry = CenterRayTarget()
			if centerEntity and centerPart and centerEntry then
				currentEntity, currentPart, currentEntry = centerEntity, centerPart, centerEntry
				lockedValid = true
			end
			if (not lockedValid) and now - (Trigger.LastScan or 0) >= (Trigger.ScanInterval or 1 / 30) then
				currentEntity, currentPart, currentEntry = FindTriggerTarget()
				Trigger.LastScan = now
			end
		end

		if not currentEntity or not currentPart or not currentEntry then
			Trigger.Player, Trigger.Part, Trigger.Target, Trigger.EnterTime = nil, nil, nil, nil
			return
		end

		if Trigger.Target ~= currentEntity then
			Trigger.Target = currentEntity
			Trigger.EnterTime = now
		end
		Trigger.Player, Trigger.Part = currentEntity, currentPart
	
		Trigger.EnterTime = Trigger.EnterTime or now
		if now - Trigger.EnterTime < math.max(S.TriggerDelay, 0) then return end
		if now < (Trigger.NextFire or 0) then return end

		if not TriggerTargetStillValid(currentEntity, currentPart, currentEntry) then return end

		if FireTrigger() then
			local interval = math.clamp(tonumber(S.TriggerInterval) or 0.02, 0.02, 0.6)
			if S.TriggerHumanize then interval *= 1 + math.random() * 0.18 end
			Trigger.NextFire = now + interval
			Combat.LastFire = now
		end
	end

	local function DrawLine(f, a, b, color, th)
		local d = b - a
		f.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
		f.Size = UDim2.fromOffset(d.Magnitude, th or 1.5)
		f.Rotation = math.deg(math.atan2(d.Y, d.X))
		f.BackgroundColor3 = color
		f.Visible = true
	end
	local NextBotId = 0
	local BotByHumanoid, BotByRoot = {}, {}

	local function IsUnderPlayerCharacter(model)
		if not model then return false end
		local cur = model
		for _ = 1, 16 do
			if not cur or cur == Workspace then break end
			if cur:IsA("Model") then
				if Players:GetPlayerFromCharacter(cur) then return true end
				for _, player in ipairs(Players:GetPlayers()) do
					if player.Character == cur then return true end
				end
			end
			cur = cur.Parent
		end
		return false
	end

	local function IsBotModel(model)
		if not model or not model:IsA("Model") or not model:IsDescendantOf(Workspace) then return false end
		if IsUnderPlayerCharacter(model) then return false end
		local hum = model:FindFirstChildOfClass("Humanoid")
		if not hum then return false end
		return (hum.RootPart or model:FindFirstChild("HumanoidRootPart")) ~= nil
	end

	local function GetBotParts(model)
		local hum = model and model:FindFirstChildOfClass("Humanoid")
		local root = hum and (hum.RootPart or model:FindFirstChild("HumanoidRootPart"))
		return hum, root
	end

	local function CanonicalBotModel(model)
		if not IsBotModel(model) then return nil end
		local hum, root = GetBotParts(model)
		if not hum or not root then return nil end
		local canonical = model
		local parent = model.Parent
		while parent and parent:IsA("Model") do
			local ph = parent:FindFirstChildOfClass("Humanoid")
			local pr = ph and (ph.RootPart or parent:FindFirstChild("HumanoidRootPart"))
			if ph == hum or pr == root then
				canonical = parent
			else
				break
			end
			parent = parent.Parent
		end
		return canonical
	end

	do
		local ok, err = pcall(function()
			local dummy = Instance.new("Model")
			dummy.Name = "VortexSelfTestDummy"
			local hum = Instance.new("Humanoid", dummy)
			local root = Instance.new("Part", dummy)
			root.Name = "HumanoidRootPart"
			IsUnderPlayerCharacter(dummy)
			IsBotModel(dummy)
			GetBotParts(dummy)
			CanonicalBotModel(dummy)
			dummy:Destroy()
		end)
		if not ok then DebugLog.Push("selftest", "bot-identity self-test failed: " .. tostring(err), true) end
	end

	local function NewEntry(entity, isBot)
		if isBot then NextBotId += 1 end
		local folderName = isBot and ("ESP_BOT_" .. tostring(NextBotId)) or ("ESP_" .. entity.UserId)
		local folder = New("Folder", Overlay, {Name = folderName})
		local e = {
			Folder = folder, Shown = false, Bones = {}, Parts = {}, TriggerParts = {}, TriggerMode = nil,
			TriggerCharacter = nil, LastToolCheck = 0, Entity = entity, IsBot = isBot == true
		}
		e.Box = New("Frame", folder, {BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 2})
		e.BoxStroke = New("UIStroke", e.Box, {Thickness = 1.5, Color = Color3.new(1,1,1)})
		e.NameLabel = New("TextLabel", folder, {AnchorPoint = Vector2.new(0.5,1), Size = UDim2.fromOffset(200,14), BackgroundTransparency = 1, Font = GOTHB,
			TextSize = 12, TextColor3 = Color3.new(1,1,1), TextStrokeTransparency = 0.35, Visible = false, ZIndex = 3})
		e.Info = New("TextLabel", folder, {AnchorPoint = Vector2.new(0.5,0), Size = UDim2.fromOffset(200,28), BackgroundTransparency = 1, Font = GOTHM,
			TextSize = 11, TextColor3 = Color3.fromRGB(220,220,228), TextStrokeTransparency = 0.45, TextYAlignment = Enum.TextYAlignment.Top, Visible = false, ZIndex = 3})
		e.HealthBack = New("Frame", folder, {BackgroundColor3 = Color3.fromRGB(10,10,10), BackgroundTransparency = 0.3, BorderSizePixel = 0, Visible = false, ZIndex = 2})
		e.HealthFill = New("Frame", e.HealthBack, {AnchorPoint = Vector2.new(0,1), Position = UDim2.fromScale(0,1), Size = UDim2.fromScale(1,1), BorderSizePixel = 0, ZIndex = 3})
		e.Dot = Round(New("Frame", folder, {AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.fromOffset(6,6), BorderSizePixel = 0, Visible = false, ZIndex = 4}), 100)
		e.Arrow = New("Frame", folder, {AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.fromOffset(12,12), Rotation = 45, BorderSizePixel = 0, Visible = false, ZIndex = 4})
		e.Tracer = New("Frame", folder, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, Visible = false, ZIndex = 1})
		for _ = 1, 14 do
			table.insert(e.Bones, New("Frame", folder, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, Visible = false, ZIndex = 2}))
		end
		function e.Refresh()
			local target = e.Entity
			local ch = e.IsBot and target or (target and target.Character)
			local hum, root = e.Humanoid, e.Root
			if e.Character ~= ch or not hum or not root or hum.Parent ~= ch or root.Parent ~= ch then
				table.clear(e.Parts)
				e.Character, e.Humanoid, e.Root, e.Tool, e.ChamColor, e.TriggerMode, e.TriggerCharacter = ch, nil, nil, nil, nil, nil, nil
				table.clear(e.TriggerParts)
				if not ch then return false end
				hum = ch:FindFirstChildOfClass("Humanoid")
				root = hum and (hum.RootPart or ch:FindFirstChild("HumanoidRootPart"))
				if not hum or not root then return false end
				e.Humanoid, e.Root = hum, root
			end
			return hum.Health > 0 and ch.Parent ~= nil and root.Parent == ch
		end
		Entries[entity] = e
		EntryIndex[entity] = #EntryOrder + 1
		EntryOrder[#EntryOrder + 1] = entity
		return e
	end
	local function NewPlayerEntry(player) return NewEntry(player, false) end
	local function NewBotEntry(model) return NewEntry(model, true) end

	local function RemoveEntry(entity)
		local e = Entries[entity]
		if not e then return end
		if e.IsBot then
			if e.Humanoid then BotByHumanoid[e.Humanoid] = nil end
			if e.Root then BotByRoot[e.Root] = nil end
		end
		if e.Cham then e.Cham:Destroy() end
		e.Folder:Destroy()
		local idx = EntryIndex[entity]
		local last = EntryOrder[#EntryOrder]
		if idx then
			EntryOrder[idx] = last
			if last ~= nil then EntryIndex[last] = idx end
			EntryOrder[#EntryOrder] = nil
			EntryIndex[entity] = nil
		end
		Entries[entity] = nil
	end
	local function HideEntry(e)
		e.Shown = false
		e.Box.Visible, e.NameLabel.Visible, e.Info.Visible, e.HealthBack.Visible, e.Dot.Visible, e.Arrow.Visible, e.Tracer.Visible = false, false, false, false, false, false, false
		if e.Corners then for _, f in ipairs(e.Corners) do f.Visible = false end end
		for _, b in ipairs(e.Bones) do b.Visible = false end
	end
	local function UpdateEntry(entity, e, heavy)
		if e.IsBot and IsUnderPlayerCharacter(e.Entity) then
			HideEntry(e)
			return
		end
		if not S.ESPEnabled or not EntryIsTargetable(entity, e, S.ESPTeamCheck, S.ESPIgnoreBots) or not e.Refresh() then HideEntry(e); return end
		local ch, hum, root = e.Character, e.Humanoid, e.Root
		local dist = (root.Position - Camera.CFrame.Position).Magnitude
		if dist > S.ESPMaxDistance then HideEntry(e); return end
		local color = ESPColors[S.ESPColor] or ESPColors.Red
		if Aim.Player == entity then color = Theme.Accent end
		local rs, on = Camera:WorldToViewportPoint(root.Position)
		if not on then
			HideEntry(e)
			if S.ShowOffscreen then
				local vp = Camera.ViewportSize
				local rel = Camera.CFrame:PointToObjectSpace(root.Position)
				local dir = Vector2.new(rel.X, -rel.Y)
				dir = dir.Magnitude < 0.0001 and Vector2.new(0,-1) or dir.Unit
				local pt = Vector2.new(vp.X / 2, vp.Y / 2) + dir * (math.min(vp.X, vp.Y) / 2 * 0.85)
				e.Arrow.Position = UDim2.fromOffset(pt.X, pt.Y)
				e.Arrow.BackgroundColor3 = color
				e.Arrow.Visible = true
				e.Shown = true
			end
			return
		end
		e.Shown = true
		local head = PartOf(e, "Head")
		local feet = hum.RigType == Enum.HumanoidRigType.R15 and (hum.HipHeight + root.Size.Y / 2) or 3
		local top = Camera:WorldToViewportPoint((head and head.Position or root.Position) + Vector3.new(0, 0.75, 0))
		local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, feet, 0))
		local topY = math.min(top.Y, bot.Y)
		local h = math.max(math.abs(bot.Y - top.Y), 10)
		local w = h * 0.55
		local x = rs.X
		if S.ShowBoxes then
			e.Box.Position = UDim2.fromOffset(x - w / 2, topY)
			e.Box.Size = UDim2.fromOffset(w, h)
			e.BoxStroke.Color = color
			e.BoxStroke.Thickness = S.CornerBoxEnabled and 0 or 1.5
			e.Box.Visible = true
			if S.CornerBoxEnabled then
				if not e.Corners then
					e.Corners = {}
					for _ = 1, 8 do table.insert(e.Corners, New("Frame", e.Box, {BorderSizePixel = 0, ZIndex = 2})) end
				end
				local len, th = math.clamp(h * 0.18, 6, 18), 2
				local segs = {{0,0,len,th},{0,0,th,len},{w-len,0,len,th},{w-th,0,th,len},{0,h-th,len,th},{0,h-len,th,len},{w-len,h-th,len,th},{w-th,h-len,th,len}}
				for i, sg in ipairs(segs) do
					local f = e.Corners[i]
					f.Position, f.Size, f.BackgroundColor3, f.Visible = UDim2.fromOffset(sg[1], sg[2]), UDim2.fromOffset(sg[3], sg[4]), color, true
				end
			elseif e.Corners then
				for _, f in ipairs(e.Corners) do f.Visible = false end
			end
		else
			e.Box.Visible = false
		end
		if S.ShowTracers then
			local vp = Camera.ViewportSize
			local o = S.TracerOrigin == "Top" and Vector2.new(vp.X / 2, 0) or (S.TracerOrigin == "Center" and Vector2.new(vp.X / 2, vp.Y / 2) or Vector2.new(vp.X / 2, vp.Y))
			DrawLine(e.Tracer, o, Vector2.new(x, topY + h), color, 1)
		else
			e.Tracer.Visible = false
		end
		if e.IsBot then
			e.NameLabel.Position = UDim2.fromOffset(x, topY - 5)
			e.NameLabel.Text = Locale.T("BOT_LABEL")
			e.NameLabel.TextColor3 = color
			e.NameLabel.Visible = true
		elseif S.ShowNames then
			e.NameLabel.Position = UDim2.fromOffset(x, topY - 5)
			e.NameLabel.Text = entity.Name
			e.NameLabel.TextColor3 = Color3.new(1,1,1)
			e.NameLabel.Visible = true
		else
			e.NameLabel.Visible = false
		end
		local lines = {}
		if S.ShowDistance then table.insert(lines, math.floor(dist) .. " m") end
		if S.ShowWeapon then
			local now = os.clock()
			if now - (e.LastToolCheck or 0) >= 0.12 or e.Tool == nil or e.Tool.Parent ~= ch then
				e.LastToolCheck = now
				e.Tool = ch:FindFirstChildOfClass("Tool")
			end
			table.insert(lines, e.Tool and e.Tool.Name or "None")
		end
		if #lines > 0 then
			e.Info.Position = UDim2.fromOffset(x, topY + h + 2)
			e.Info.Text = table.concat(lines, "\n")
			e.Info.Visible = true
		else
			e.Info.Visible = false
		end
		if S.ShowHealth then
			local mh = hum.MaxHealth > 0 and hum.MaxHealth or 100
			local pc = math.clamp(hum.Health / mh, 0, 1)
			e.HealthBack.Position = UDim2.fromOffset(x - w / 2 - 6, topY)
			e.HealthBack.Size = UDim2.fromOffset(3, h)
			e.HealthFill.Size = UDim2.fromScale(1, pc)
			e.HealthFill.BackgroundColor3 = Color3.fromHSV(pc * 0.33, 0.85, 1)
			e.HealthBack.Visible = true
		else
			e.HealthBack.Visible = false
		end
		if S.ShowHeadDot and head then
			local hs, ho = Camera:WorldToViewportPoint(head.Position)
			e.Dot.Visible = ho
			if ho then e.Dot.Position = UDim2.fromOffset(hs.X, hs.Y); e.Dot.BackgroundColor3 = color end
		else
			e.Dot.Visible = false
		end
		if S.ShowSkeleton and heavy then
			local bones = hum.RigType == Enum.HumanoidRigType.R15 and R15Bones or R6Bones
			for i, line in ipairs(e.Bones) do
				local vis, pair = false, bones[i]
				if pair then
					local a, b = PartOf(e, pair[1]), PartOf(e, pair[2])
					if a and b then
						local pa, pb = Camera:WorldToViewportPoint(a.Position), Camera:WorldToViewportPoint(b.Position)
						if pa.Z > 0 and pb.Z > 0 then
							DrawLine(line, Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y), color, 1.5)
							vis = true
						end
					end
				end
				line.Visible = vis
			end
		elseif not S.ShowSkeleton then
			for _, line in ipairs(e.Bones) do line.Visible = false end
		end
		e.Arrow.Visible = false
	end
	local function UpdateCham(entity, e)
		local ch = e.Character or (e.IsBot and e.Entity or entity.Character)
		if S.ChamsEnabled and ch ~= nil and EntryIsTargetable(entity, e, S.ESPTeamCheck, S.ESPIgnoreBots) then
			if not e.Cham or e.Cham.Parent ~= ch then
				if e.Cham then e.Cham:Destroy() end
				e.Cham = New("Highlight", ch, {Name = "VortexCham", DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, FillTransparency = 0.6, OutlineTransparency = 0})
				e.ChamColor = nil
			end
			local color = Aim.Player == entity and Theme.Accent or (ESPColors[S.ESPColor] or ESPColors.Red)
			if e.ChamColor ~= color then e.Cham.FillColor, e.Cham.OutlineColor, e.ChamColor = color, color, color end
		elseif e.Cham then
			e.Cham:Destroy(); e.Cham, e.ChamColor = nil, nil
		end
	end

	local CachedChar, CachedHum
	local function GetHumanoid()
		local ch = LocalPlayer.Character
		if not ch then CachedChar, CachedHum = nil, nil; return nil end
		if ch ~= CachedChar or not CachedHum or CachedHum.Parent ~= ch then
			CachedChar, CachedHum = ch, ch:FindFirstChildOfClass("Humanoid")
		end
		return CachedHum
	end
	local function UpdateMovement()
		local hum = GetHumanoid()
		if not hum then Applied.Humanoid, Applied.Speed, Applied.Jump = nil, false, false; return end
		if Applied.Humanoid ~= hum then Applied.Humanoid, Applied.Speed, Applied.Jump = hum, false, false end
		if S.SpeedEnabled then
			if not Applied.Speed then Applied.Speed = true; Applied.WalkSpeed = hum.WalkSpeed end
			hum.WalkSpeed = S.SpeedValue
		elseif Applied.Speed then
			Applied.Speed = false; hum.WalkSpeed = Applied.WalkSpeed
		end
		if S.JumpEnabled then
			if not Applied.Jump then Applied.Jump = true; Applied.UseJumpPower = hum.UseJumpPower; Applied.JumpPower = hum.JumpPower end
			hum.UseJumpPower = true
			hum.JumpPower = S.JumpValue
		elseif Applied.Jump then
			Applied.Jump = false; hum.UseJumpPower = Applied.UseJumpPower; hum.JumpPower = Applied.JumpPower
		end
	end
	function Fly.Stop()
		for _, k in ipairs({"Velocity", "Align", "Attach"}) do
			if Fly[k] then Fly[k]:Destroy(); Fly[k] = nil end
		end
		if Fly.Active then
			Fly.Active = false
			local hum = GetHumanoid()
			if hum then hum.PlatformStand = false end
		end
	end
	function Fly.Update()
		if not S.FlyEnabled then
			if Fly.Active then Fly.Stop() end
			return
		end
		local hum = GetHumanoid()
		local root = hum and hum.RootPart
		if not root or hum.Health <= 0 then return end
		if not Fly.Attach or Fly.Attach.Parent ~= root then
			Fly.Stop()
			Fly.Attach = New("Attachment", root, {Name = "VortexFlyAttachment"})
			Fly.Velocity = New("LinearVelocity", root, {Attachment0 = Fly.Attach, MaxForce = 1e9, RelativeTo = Enum.ActuatorRelativeTo.World,
				VelocityConstraintMode = Enum.VelocityConstraintMode.Vector, VectorVelocity = Vector3.zero})
			Fly.Align = New("AlignOrientation", root, {Attachment0 = Fly.Attach, Mode = Enum.OrientationAlignmentMode.OneAttachment, MaxTorque = 1e9, Responsiveness = 50})
			Fly.Active = true
		end
		hum.PlatformStand = true
		local look = Camera.CFrame
		local dir = (UserInputService:GetFocusedTextBox() or Freecam.Active) and Vector3.zero or MoveDir(look)
		if dir.Magnitude > 0 then dir = dir.Unit end
		Fly.Velocity.VectorVelocity = dir * S.FlySpeed
		local flat = Vector3.new(look.LookVector.X, 0, look.LookVector.Z)
		if flat.Magnitude > 0.01 then Fly.Align.CFrame = CFrame.lookAt(root.Position, root.Position + flat) end
	end

	for _, c in ipairs(Lighting:GetChildren()) do
		if string.sub(c.Name, 1, 6) == "Vortex" then c:Destroy() end
	end
	local oldAnchor = Workspace:FindFirstChild("VortexWeatherAnchor")
	if oldAnchor then oldAnchor:Destroy() end

	local FX = {}
	FX.Grade = New("ColorCorrectionEffect", Lighting, {Name = "VortexGrade", Enabled = false})
	FX.Vision = New("ColorCorrectionEffect", Lighting, {Name = "VortexVision", Enabled = false})
	FX.Flash = New("ColorCorrectionEffect", Lighting, {Name = "VortexFlash", Enabled = false})
	FX.Bloom = New("BloomEffect", Lighting, {Name = "VortexBloom", Intensity = 0, Size = 24, Threshold = 0.8, Enabled = false})
	FX.Rays = New("SunRaysEffect", Lighting, {Name = "VortexRays", Intensity = 0, Spread = 0.5, Enabled = false})
	FX.Depth = New("DepthOfFieldEffect", Lighting, {Name = "VortexDepth", Enabled = false, FarIntensity = 0, NearIntensity = 0, FocusDistance = 50, InFocusRadius = 30})
	FX.Blur = New("BlurEffect", Lighting, {Name = "VortexBlur", Size = 0, Enabled = false})

	local AtmosphereObject = Lighting:FindFirstChildOfClass("Atmosphere")
	local AtmosphereOwned = false
	if not AtmosphereObject then
		AtmosphereObject = New("Atmosphere", Lighting, {Name = "VortexAtmosphere", Density = 0, Offset = 0, Haze = 0, Glare = 0})
		AtmosphereOwned = true
	end
	local Clouds = Workspace.Terrain:FindFirstChildOfClass("Clouds")
	local WeatherPart = New("Part", Workspace, {Name = "VortexWeatherAnchor", Size = Vector3.new(80,1,80), Transparency = 1, CanCollide = false, CanQuery = false,
		CanTouch = false, Anchored = true, Locked = true})
	local SnowEmitter = New("ParticleEmitter", WeatherPart, {Name = "VortexSnow", Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Color = ColorSequence.new(Color3.fromRGB(255,255,255)), Size = NumberSequence.new(0.35),
		Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.1), NumberSequenceKeypoint.new(1,0.5)}), Lifetime = NumberRange.new(5,8),
		Speed = NumberRange.new(3,6), EmissionDirection = Enum.NormalId.Bottom, SpreadAngle = Vector2.new(20,20), Rotation = NumberRange.new(0,360),
		RotSpeed = NumberRange.new(-40,40), Acceleration = Vector3.new(4,-2,0), LightEmission = 0.4, Rate = 0})
	local RainEmitter = New("ParticleEmitter", WeatherPart, {Name = "VortexRain", Color = ColorSequence.new(Color3.fromRGB(170,200,230)), Size = NumberSequence.new(0.35),
		Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.3), NumberSequenceKeypoint.new(1,0.5)}), Lifetime = NumberRange.new(0.6,0.8),
		Speed = NumberRange.new(60,80), EmissionDirection = Enum.NormalId.Bottom, SpreadAngle = Vector2.new(2,2), Orientation = Enum.ParticleOrientation.VelocityParallel,
		Acceleration = Vector3.new(0,-30,0), Rate = 0})
	local AshEmitter = New("ParticleEmitter", WeatherPart, {Name = "VortexAsh", Color = ColorSequence.new(Color3.fromRGB(120,100,90), Color3.fromRGB(70,60,55)),
		Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.15), NumberSequenceKeypoint.new(1,0.05)}),
		Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2), NumberSequenceKeypoint.new(1,0.8)}), Lifetime = NumberRange.new(6,10),
		Speed = NumberRange.new(1,3), EmissionDirection = Enum.NormalId.Bottom, SpreadAngle = Vector2.new(35,35), Rotation = NumberRange.new(0,360),
		RotSpeed = NumberRange.new(-20,20), Acceleration = Vector3.new(0,-1,0), LightEmission = 0.15, Rate = 0})

	local Vignette = {}
	for _, d in ipairs({{UDim2.fromScale(0,0), UDim2.new(1,0,0.3,0), 90}, {UDim2.fromScale(0,0.7), UDim2.new(1,0,0.3,0), -90},
		{UDim2.fromScale(0,0), UDim2.new(0.25,0,1,0), 0}, {UDim2.fromScale(0.75,0), UDim2.new(0.25,0,1,0), 180}}) do
		local f = New("Frame", Overlay, {Position = d[1], Size = d[2], BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 0})
		New("UIGradient", f, {Rotation = d[3], Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})})
		table.insert(Vignette, f)
	end
	local function FlashLightning()
		task.spawn(function()
			for _, st in ipairs({0.5, 0.25, 0.75}) do
				if Unloaded or not FX.Flash.Parent then return end
				FX.Flash.Brightness = st
				Tween(FX.Flash, {Brightness = 0}, 0.18, Enum.EasingStyle.Quad)
				task.wait(0.1 + math.random() * 0.12)
			end
		end)
	end

	local Saved = {}
	local function Ovr(id, on, save, apply, restore)
		local e = Saved[id]
		if on then
			if not e then e = {v = save(), r = restore}; Saved[id] = e end
			apply()
		elseif e then
			Saved[id] = nil
			restore(e.v)
		end
	end

	function World.Update(dt)
		WeatherPart.CFrame = CFrame.new(Camera.CFrame.Position + Vector3.new(0, 35, 0))
		SnowEmitter.Rate = S.SnowEnabled and S.SnowIntensity * 3 or 0
		RainEmitter.Rate = S.RainEnabled and S.RainIntensity * 6 or 0
		AshEmitter.Rate = S.AshEnabled and S.AshIntensity or 0
		SnowEmitter.Acceleration = Vector3.new(S.WindStrength, -2, S.WindStrength * 0.4)
		RainEmitter.Acceleration = Vector3.new(S.WindStrength * 2, -30, S.WindStrength * 0.6)
		AshEmitter.Acceleration = Vector3.new(S.WindStrength * 0.5, -1, S.WindStrength * 0.25)

		Ovr("fog", S.FogEnabled or S.FullBrightEnabled, function() return {Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor} end,
			function()
				if S.FogEnabled then Lighting.FogStart = 0; Lighting.FogEnd = S.FogDensity; Lighting.FogColor = TintColor(S.FogColorName)
				else Lighting.FogEnd = 1e6 end
			end,
			function(v) Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = v[1], v[2], v[3] end)

		FX.Flash.Enabled = S.LightningEnabled
		if S.LightningEnabled and os.clock() >= World.NextFlash then
			World.NextFlash = os.clock() + S.LightningInterval * (0.5 + math.random())
			FlashLightning()
		end
		FX.Bloom.Enabled = S.GlowEnabled
		FX.Bloom.Intensity = S.GlowIntensity * 3
		FX.Bloom.Size = S.GlowSize
		FX.Grade.Enabled = S.ColorGradeEnabled
		if S.ColorGradeEnabled then
			FX.Grade.Saturation = S.ColorSaturation
			FX.Grade.Contrast = S.ColorContrast
			FX.Grade.Brightness = S.ColorBrightness
			FX.Grade.TintColor = TintColor(S.ColorTintName)
		end
		local vis = VisionPresets[S.VisionMode]
		FX.Vision.Enabled = vis ~= nil
		if vis then
			FX.Vision.Saturation, FX.Vision.Contrast, FX.Vision.Brightness, FX.Vision.TintColor = vis.Saturation, vis.Contrast, vis.Brightness, vis.Tint
		end
		FX.Rays.Enabled, FX.Rays.Intensity, FX.Rays.Spread = S.SunRaysEnabled, S.SunRaysIntensity, S.SunRaysSpread
		FX.Depth.Enabled, FX.Depth.FocusDistance, FX.Depth.FarIntensity, FX.Depth.NearIntensity, FX.Depth.InFocusRadius = S.DOFEnabled, S.DOFFocus, S.DOFFar, S.DOFNear, S.DOFRadius
		FX.Blur.Enabled, FX.Blur.Size = S.BlurEnabled, S.BlurSize
		for _, f in ipairs(Vignette) do
			f.Visible = S.VignetteEnabled
			f.BackgroundTransparency = 1 - S.VignetteIntensity
		end

		Ovr("atmo", S.AtmosphereEnabled, function()
				local a = AtmosphereObject
				return {a.Density, a.Offset, a.Color, a.Decay, a.Glare, a.Haze}
			end,
			function()
				local col = TintColor(S.AtmoColorName)
				local a = AtmosphereObject
				a.Density, a.Haze, a.Color, a.Decay, a.Glare, a.Offset = S.AtmoDensity, S.AtmoHaze, col, col, 0.3, 0.25
			end,
			function(v) local a = AtmosphereObject; a.Density, a.Offset, a.Color, a.Decay, a.Glare, a.Haze = v[1], v[2], v[3], v[4], v[5], v[6] end)

		Ovr("clock", S.FullBrightEnabled or S.TimeOfDayEnabled or S.TimeFlowEnabled, function() return {Lighting.ClockTime} end,
			function()
				if S.TimeFlowEnabled then
					World.Flow = ((World.Flow or (S.TimeOfDayEnabled and S.TimeOfDay or Lighting.ClockTime)) + S.TimeFlowSpeed * dt) % 24
					Lighting.ClockTime = World.Flow
				elseif S.TimeOfDayEnabled then
					World.Flow = nil; Lighting.ClockTime = S.TimeOfDay
				else
					World.Flow = nil; Lighting.ClockTime = 14
				end
			end,
			function(v) World.Flow = nil; Lighting.ClockTime = v[1] end)

		Ovr("shadows", S.NoShadowsEnabled or S.FullBrightEnabled, function() return {Lighting.GlobalShadows} end,
			function() Lighting.GlobalShadows = false end, function(v) Lighting.GlobalShadows = v[1] end)

		Ovr("amb", S.FullBrightEnabled or S.RainbowEnabled or S.AmbientEnabled, function()
				return {Lighting.Brightness, Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom}
			end,
			function()
				if S.FullBrightEnabled then
					Lighting.Brightness = 2
					Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(178,178,178), Color3.fromRGB(178,178,178)
				end
				if S.RainbowEnabled then
					local hue = (os.clock() * S.RainbowSpeed) % 1
					Lighting.ColorShift_Top = Color3.fromHSV(hue, 0.7, 1)
					Lighting.ColorShift_Bottom = Color3.fromHSV((hue + 0.5) % 1, 0.7, 1)
					if not S.FullBrightEnabled then
						Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromHSV(hue, 0.45, 0.7), Color3.fromHSV(hue, 0.45, 0.7)
					end
				end
				if S.AmbientEnabled and not S.FullBrightEnabled and not S.RainbowEnabled then
					local col = TintColor(S.AmbientColorName)
					local mixed = col:Lerp(Color3.fromRGB(128,128,128), 1 - S.AmbientIntensity)
					Lighting.Ambient, Lighting.OutdoorAmbient = mixed, mixed
				end
			end,
			function(v)
				Lighting.Brightness, Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom = v[1], v[2], v[3], v[4], v[5]
			end)

		Ovr("stars", S.StarsEnabled, function() return {Lighting.StarCount} end,
			function() Lighting.StarCount = S.StarCount end, function(v) Lighting.StarCount = v[1] end)

		Ovr("exposure", S.ExposureEnabled, function() return {Lighting.ExposureCompensation} end,
			function() Lighting.ExposureCompensation = S.Exposure end, function(v) Lighting.ExposureCompensation = v[1] end)
		if Clouds then
			Ovr("clouds", S.HideCloudsEnabled, function() return {Clouds.Enabled} end,
				function() Clouds.Enabled = false end, function(v) Clouds.Enabled = v[1] end)
		end
		Ovr("gravity", S.GravityEnabled, function() return {Workspace.Gravity} end,
			function() Workspace.Gravity = S.GravityValue end, function(v) Workspace.Gravity = v[1] end)
		Ovr("zoomlimit", S.ZoomLimitEnabled, function() return {LocalPlayer.CameraMaxZoomDistance} end,
			function() LocalPlayer.CameraMaxZoomDistance = S.ZoomLimit end, function(v) LocalPlayer.CameraMaxZoomDistance = v[1] end)

		if not Freecam.Active then
			local held = S.ZoomEnabled and K.Zoom ~= Enum.KeyCode.Unknown and not UserInputService:GetFocusedTextBox() and UserInputService:IsKeyDown(K.Zoom)
			local desired = held and S.ZoomFOV or (S.CustomFOVEnabled and S.CameraFOV) or nil
			local a = 1 - math.exp(-16 * dt)
			if desired then
				if not World.FovOn then World.FovOn = true; World.FovBase = Camera.FieldOfView end
				Camera.FieldOfView += (desired - Camera.FieldOfView) * a
			elseif World.FovOn then
				Camera.FieldOfView += (World.FovBase - Camera.FieldOfView) * a
				if math.abs(Camera.FieldOfView - World.FovBase) < 0.1 then Camera.FieldOfView = World.FovBase; World.FovOn = false end
			end
		end
	end
	function World.Restore()
		for _, e in pairs(Saved) do pcall(e.r, e.v) end
		table.clear(Saved)
		if World.FovOn then Camera.FieldOfView = World.FovBase; World.FovOn = false end
		if AtmosphereOwned then AtmosphereObject:Destroy() end
		for _, fx in pairs(FX) do fx:Destroy() end
		WeatherPart:Destroy()
	end

	local FovFrame = Round(New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(300,300),
		BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false}), 100)
	New("UIStroke", FovFrame, {Color = "@Accent", Thickness = 1.5, Transparency = 0.35})
	local TriggerFovFrame = Round(New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(10,10),
		BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false}), 100)
	local TriggerFovStroke = New("UIStroke", TriggerFovFrame, {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.1})
	local TargetLine = New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, BackgroundColor3 = "@Accent", BackgroundTransparency = 0.2, Visible = false})
	local HudFrame = Round(New("Frame", Overlay, {Position = UDim2.fromOffset(16,16), Size = UDim2.fromOffset(190,34), BackgroundColor3 = "@Background",
		BackgroundTransparency = 0.15, BorderSizePixel = 0, Visible = false}), 8)
	New("UIStroke", HudFrame, {Color = "@Border", Thickness = 1})
	New("Frame", HudFrame, {Size = UDim2.fromOffset(3,18), Position = UDim2.fromOffset(8,8), BackgroundColor3 = "@Accent", BorderSizePixel = 0})
	local HudText = New("TextLabel", HudFrame, {Position = UDim2.fromOffset(20,0), Size = UDim2.new(1,-28,1,0), BackgroundTransparency = 1, Text = "FPS 0",
		TextColor3 = "@Text", Font = GOTHM, TextSize = 13, TextXAlignment = LEFT})

	local Cross = {Lines = {}, Extra = 0}
	Cross.Holder = New("Frame", Overlay, {Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(0,0), BackgroundTransparency = 1, Visible = false, ZIndex = 7})
	for i = 1, 5 do
		local line = New("Frame", Cross.Holder, {BorderSizePixel = 0, ZIndex = 7})
		New("UIStroke", line, {Color = Color3.new(0,0,0), Thickness = 1, Transparency = 0.3})
		Cross.Lines[i] = line
	end
	local function GetPing()
		local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
		return ok and math.floor(v) or 0
	end
	local function UpdateCrosshair(dt)
		Cross.Holder.Visible = S.CrosshairEnabled
		if not S.CrosshairEnabled then return end
		local hum = GetHumanoid()
		local moving = hum ~= nil and hum.MoveDirection.Magnitude > 0.1
		Cross.Extra += (((S.CrosshairDynamic and moving) and 6 or 0) - Cross.Extra) * (1 - math.exp(-12 * dt))
		local gap, len, th = S.CrosshairGap + Cross.Extra, S.CrosshairSize, S.CrosshairThickness
		local color
		if S.CrosshairReactive and (Trigger.Player or Aim.Player) then color = ESPColors.Red
		elseif S.CrosshairColorName == "Theme" then color = Theme.Accent
		else color = ESPColors[S.CrosshairColorName] or ESPColors.White end
		local l = Cross.Lines
		l[1].Position, l[1].Size = UDim2.fromOffset(-th / 2, -(gap + len)), UDim2.fromOffset(th, len)
		l[2].Position, l[2].Size = UDim2.fromOffset(-th / 2, gap), UDim2.fromOffset(th, len)
		l[3].Position, l[3].Size = UDim2.fromOffset(-(gap + len), -th / 2), UDim2.fromOffset(len, th)
		l[4].Position, l[4].Size = UDim2.fromOffset(gap, -th / 2), UDim2.fromOffset(len, th)
		local dot = th + 1
		l[5].Position, l[5].Size, l[5].Visible = UDim2.fromOffset(-dot / 2, -dot / 2), UDim2.fromOffset(dot, dot), S.CrosshairDot
		for _, ln in ipairs(l) do ln.BackgroundColor3 = color end
		Cross.Holder.Rotation = S.CrosshairSpin and (Cross.Holder.Rotation + 120 * dt) % 360 or 0
	end

	local Hit = {Lines = {}, Sparks = {}, Branches = {}, Token = 0}
	Hit.Holder = New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(0,0), BackgroundTransparency = 1, ZIndex = 8})
	Hit.Scale = New("UIScale", Hit.Holder, {Scale = 1})
	Hit.Ring = Round(New("Frame", Hit.Holder, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(18,18), BackgroundTransparency = 1, Visible = false, ZIndex = 8}), 100)
	Hit.RingStroke = New("UIStroke", Hit.Ring, {Thickness = 2, Transparency = 1, Color = Color3.new(1,1,1)})
	Hit.Text = New("TextLabel", Hit.Holder, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(90,36), BackgroundTransparency = 1, Text = "", Visible = false, TextColor3 = Color3.new(1,1,1), TextStrokeTransparency = 0.25, Font = GOTHB, TextSize = 24, ZIndex = 9})
	for i = 1, 8 do
		local line = New("Frame", Hit.Holder, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(12,2), Rotation = 0, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, Visible = false, ZIndex = 8})
		Hit.Lines[i] = line
	end
	for i = 1, 12 do
		Hit.Sparks[i] = New("Frame", Hit.Holder, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(3,3), BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, Visible = false, ZIndex = 9})
	end
	for i = 1, 6 do
		Hit.Branches[i] = New("Frame", Hit.Holder, {AnchorPoint = Vector2.new(0,0.5), Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(30,2), Rotation = 0, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, Visible = false, ZIndex = 9})
	end
	Hit.Sound = New("Sound", Overlay, {SoundId = "rbxasset://sounds/electronicpingshort.wav", Volume = 0.5})

	local function HitHideAll()
		Hit.Ring.Visible = false
		Hit.RingStroke.Transparency = 1
		Hit.Text.Visible = false
		for _, line in ipairs(Hit.Lines) do line.Visible = false end
		for _, f in ipairs(Hit.Sparks) do f.Visible = false end
		for _, f in ipairs(Hit.Branches) do f.Visible = false end
	end

	local function HitLine(line, angle, length, thickness, color, duration, startRadius)
		line.Visible = true
		line.BackgroundColor3 = color
		line.BackgroundTransparency = 0
		line.Rotation = angle
		line.Size = UDim2.fromOffset(length, thickness)
		local rad = math.rad(angle)
		line.Position = UDim2.fromOffset(math.cos(rad) * startRadius, math.sin(rad) * startRadius)
		Tween(line, {Position = UDim2.fromOffset(math.cos(rad) * (startRadius + length * 0.55), math.sin(rad) * (startRadius + length * 0.55)), BackgroundTransparency = 1}, duration, Enum.EasingStyle.Quad)
	end

	local function ShowHitStyle(style, color, size, duration)
		local len = 10 * size
		local th = math.max(2, math.floor(2 * size + 0.5))
		if style == "Cross" then
			for i, a in ipairs({45,135,225,315}) do HitLine(Hit.Lines[i], a, len, th, color, duration, 8 * size) end
		elseif style == "X" then
			for i, a in ipairs({45,135}) do HitLine(Hit.Lines[i], a, len * 1.15, th, color, duration, 8 * size) end
		elseif style == "Plus" then
			for i, a in ipairs({0,90,180,270}) do HitLine(Hit.Lines[i], a, len, th, color, duration, 8 * size) end
		elseif style == "Circle" then
			Hit.Ring.Visible = true; Hit.Ring.Size = UDim2.fromOffset(14 * size,14 * size); Hit.RingStroke.Color = color; Hit.RingStroke.Transparency = 0
			Tween(Hit.RingStroke, {Transparency = 1}, duration, Enum.EasingStyle.Quad)
			Tween(Hit.Ring, {Size = UDim2.fromOffset(42 * size,42 * size)}, duration, Enum.EasingStyle.Quad)
		elseif style == "Diamond" then
			for i, a in ipairs({45,135,225,315}) do HitLine(Hit.Lines[i], a, len * 0.75, th, color, duration, 0) end
		elseif style == "Star" then
			for i, a in ipairs({0,45,90,135,180,225,270,315}) do HitLine(Hit.Lines[i], a, len * 0.85, math.max(1, th - 1), color, duration, 5 * size) end
		elseif style == "Brackets" then
			local data = {{-1,-1,0},{-1,-1,90},{1,-1,180},{1,-1,90},{-1,1,270},{-1,1,0},{1,1,90},{1,1,180}}
			for i, d in ipairs(data) do HitLine(Hit.Lines[i], d[3], len * 0.75, th, color, duration, 10 * size) end
		elseif style == "Dot" then
			Hit.Text.Visible = true; Hit.Text.Text = "."; Hit.Text.TextSize = math.max(18, math.floor(26 * size)); Hit.Text.TextColor3 = color
			Tween(Hit.Text, {TextTransparency = 1}, duration, Enum.EasingStyle.Quad)
		elseif style == "Hit" then
			Hit.Text.Visible = true; Hit.Text.Text = "HIT"; Hit.Text.TextSize = math.max(14, math.floor(22 * size)); Hit.Text.TextColor3 = color
			Tween(Hit.Text, {TextTransparency = 1, Size = UDim2.fromOffset(110 * size, 48 * size)}, duration, Enum.EasingStyle.Back)
		elseif style == "Skull" then
			Hit.Text.Visible = true; Hit.Text.Text = "X"; Hit.Text.TextSize = math.max(20, math.floor(30 * size)); Hit.Text.TextColor3 = color
			Tween(Hit.Text, {TextTransparency = 1}, duration, Enum.EasingStyle.Quad)
		elseif style == "Lightning" then
			for i, a in ipairs({-62,-31,0,31,62}) do HitLine(Hit.Lines[i], a - 90, len * 0.9, math.max(1, th - 1), color, duration, 8 * size) end
		end
	end

	local function ShowExplosion(color, size, duration)
		for i = 1, #Hit.Sparks do
			local f = Hit.Sparks[i]
			local a = (i - 1) * (360 / #Hit.Sparks) + math.random(-14,14)
			local rad = math.rad(a)
			f.Position = UDim2.fromOffset(math.cos(rad) * 5, math.sin(rad) * 5)
			f.Size = UDim2.fromOffset(math.max(2, 4 * size), math.max(2, 4 * size))
			f.BackgroundColor3 = color
			f.BackgroundTransparency = 0
			f.Visible = true
			Tween(f, {Position = UDim2.fromOffset(math.cos(rad) * 40 * size, math.sin(rad) * 40 * size), BackgroundTransparency = 1, Size = UDim2.fromOffset(1,1)}, duration, Enum.EasingStyle.Quad)
		end
		Hit.Ring.Visible = true; Hit.Ring.Size = UDim2.fromOffset(8 * size,8 * size); Hit.RingStroke.Color = color; Hit.RingStroke.Transparency = 0
		Tween(Hit.Ring, {Size = UDim2.fromOffset(70 * size,70 * size)}, duration, Enum.EasingStyle.Quint)
		Tween(Hit.RingStroke, {Transparency = 1}, duration, Enum.EasingStyle.Quad)
	end

	local function ShowLightning(color, size, duration)
		for i = 1, #Hit.Branches do
			local f = Hit.Branches[i]
			local a = -75 + (i - 1) * 30 + math.random(-6,6)
			local rad = math.rad(a)
			f.Position = UDim2.fromOffset(0,0)
			f.Size = UDim2.fromOffset(24 * size, math.max(1, 2 * size))
			f.Rotation = a
			f.BackgroundColor3 = color
			f.BackgroundTransparency = 0
			f.Visible = true
			Tween(f, {Position = UDim2.fromOffset(math.cos(rad) * 24 * size, math.sin(rad) * 24 * size), BackgroundTransparency = 1}, duration, Enum.EasingStyle.Quad)
		end
		Hit.Text.Visible = true; Hit.Text.Text = "!"; Hit.Text.TextSize = math.max(22, math.floor(30 * size)); Hit.Text.TextColor3 = color
		Tween(Hit.Text, {TextTransparency = 1, Position = UDim2.fromOffset(0,-10 * size)}, duration, Enum.EasingStyle.Quad)
	end

	function Hit.Show(kill)
		Hit.Token += 1
		local token = Hit.Token
		HitHideAll()
		local color = kill and Color3.fromRGB(255,70,80) or Color3.new(1,1,1)
		local style = S.HitMarkerStyle or "Cross"
		local size = math.clamp(tonumber(S.HitMarkerSize) or 1, 0.5, 2.5)
		local duration = math.clamp(tonumber(S.HitMarkerLifetime) or 0.45, 0.12, 1.2)
		Hit.Scale.Scale = 1.45 * size
		Tween(Hit.Scale, {Scale = size}, 0.18, Enum.EasingStyle.Back)
		ShowHitStyle(style, color, size, duration)

		local effect = S.HitEffect or "Pulse"
		if effect == "Pulse" or effect == "Pulse+Explosion" or effect == "Pulse+Lightning" or effect == "All" then
			Hit.Ring.Visible = true; Hit.Ring.Size = UDim2.fromOffset(10 * size,10 * size); Hit.RingStroke.Color = color; Hit.RingStroke.Transparency = 0
			Tween(Hit.Ring, {Size = UDim2.fromOffset(52 * size,52 * size)}, duration, Enum.EasingStyle.Quint)
			Tween(Hit.RingStroke, {Transparency = 1}, duration, Enum.EasingStyle.Quad)
		end
		if effect == "Explosion" or effect == "Pulse+Explosion" or effect == "Explosion+Lightning" or effect == "All" or style == "Hit" and kill then
			ShowExplosion(color, size, duration)
		end
		if effect == "Lightning" or effect == "Pulse+Lightning" or effect == "Explosion+Lightning" or effect == "All" or style == "Lightning" then
			ShowLightning(color, size, duration)
		end

		if S.HitSoundEnabled then
			pcall(function() Hit.Sound.PlaybackSpeed = kill and 1.5 or 1.1; Hit.Sound:Play() end)
		end
		task.delay(duration + 0.05, function()
			if token == Hit.Token then HitHideAll() end
		end)
	end

	local function TrackHits(entity, e, firing)
		if not EntryIsTargetable(entity, e, true, false) then e.LastHealth = nil; return end
		local alive = e.Refresh()
		local hum = e.Humanoid
		if not hum then e.LastHealth = nil; return end
		local hp = hum.Health
		if e.LastHealth and hp < e.LastHealth - 0.01 and firing then Hit.Show(hp <= 0) end
		e.LastHealth = alive and hp or nil
	end
	local OverlayRuntime = {
		EntryBudget = 0,
		Cursor = 1,
	}
	local function UpdateOverlay(dt)
		local vp = Camera.ViewportSize
		FovFrame.Size = UDim2.fromOffset(S.FOVRadius * 2, S.FOVRadius * 2)
		FovFrame.Visible = S.ShowFOV and S.AimbotEnabled

		local tv = S.ShowTriggerFOV and S.TriggerEnabled
		TriggerFovFrame.Visible = tv
		if tv then
			local sz = math.max(S.TriggerFOV * 2, 4)
			TriggerFovFrame.Size = UDim2.fromOffset(sz, sz)
			TriggerFovStroke.Color = Trigger.Player and ESPColors.Red or Theme.Accent
		end

		if S.ShowTargetLine and S.AimbotEnabled and Aim.Position then
			local sc, on = Camera:WorldToViewportPoint(Aim.Position)
			if on then
				DrawLine(TargetLine, Vector2.new(vp.X * 0.5, vp.Y * 0.5), Vector2.new(sc.X, sc.Y), Theme.Accent, 1.5)
			else
				TargetLine.Visible = false
			end
		else
			TargetLine.Visible = false
		end

		local count = #EntryOrder
		if count > 0 then
			local now = os.clock()
			local firing = (now - Combat.LastFire < 0.35) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			for i = 1, count do
				local entity = EntryOrder[i]
				local e = entity and Entries[entity]
				if e and e.Folder.Parent then
					UpdateEntry(entity, e, S.ShowSkeleton)
					if S.ChamsEnabled or e.Cham then UpdateCham(entity, e) end
					if S.HitMarkerEnabled then
						TrackHits(entity, e, firing)
					else
						e.LastHealth = nil
					end
				end
			end
		else
			OverlayRuntime.Cursor = 1
		end

		UpdateCrosshair(dt)
		HudFrame.Visible = S.HUDEnabled
		if S.HUDEnabled then
			Hud.Accum += dt; Hud.Frames += 1
			if Hud.Accum >= 0.25 then
				HudText.Text = string.format("%s %d   |   %s %d ms", Locale.T("LBL_FPS"), math.floor(Hud.Frames / Hud.Accum + 0.5), Locale.T("LBL_PING"), GetPing())
				Hud.Accum, Hud.Frames = 0, 0
			end
		end
	end


	local function ApplyPreset(name)
		if name == "None" then return end
		for _, k in ipairs(WorldKeys) do SetValue(k, Defaults[k]) end
		local p = Presets[name]
		if p then for k, v in pairs(p) do SetValue(k, v) end end
		Notify(string.format(Locale.T("TOAST_PRESET"), name))
	end
	Hooks.WorldPreset = ApplyPreset

	local function SerializeConfig()
		local parts = {}
		for k, v in pairs(S) do
			local t = type(v)
			if t == "boolean" then table.insert(parts, k .. "=" .. (v and "1" or "0"))
			elseif t == "number" or t == "string" then table.insert(parts, k .. "=" .. tostring(v)) end
		end
		table.sort(parts)
		local tp = {}
		for _, k in ipairs(ThemeKeys) do
			local c = Themes.Custom[k]
			table.insert(tp, k .. ":" .. math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5))
		end
		return table.concat(parts, ";") .. "||" .. table.concat(tp, ";")
	end
	local ClampTable = {}
	local function DeserializeConfig(text)
		local applied = 0
		text = string.match(text, "^%s*(.-)%s*$") or text
		local body, themePart = string.match(text, "^(.-)||(.*)$")
		body = body or text
		for pair in string.gmatch(body, "[^;]+") do
			local k, raw = string.match(pair, "^(.-)=(.*)$")
			if k and raw and S[k] ~= nil and k ~= "WorldPreset" then
				local cur, nv = S[k], raw
				if type(cur) == "boolean" then nv = raw == "1" elseif type(cur) == "number" then nv = tonumber(raw) end
				if type(nv) == "number" then
					local range = ClampTable[k]
					if range then nv = math.clamp(nv, range.min, range.max) end
				end
				if nv ~= nil then SetValue(k, nv); applied += 1 end
			end
		end
		if themePart then
			for entry in string.gmatch(themePart, "[^;]+") do
				local k, r, g, b = string.match(entry, "^(.-):(%d+),(%d+),(%d+)$")
				if k and Themes.Custom[k] then Themes.Custom[k] = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)); applied += 1 end
			end
			ApplyTheme()
		end
		return applied
	end

	local ConfigListText = "-"
	local ConfigIndex = {}
	local function RefreshConfigList()
		table.clear(ConfigIndex)
		local names = ListConfigs()
		for _, n in ipairs(names) do
			local ok, content = pcall(readfile, CONFIG_FOLDER .. "/" .. n .. ".cfg")
			if ok then ConfigIndex[n] = content end
		end
		ConfigListText = #names == 0 and Locale.T("TOAST_NOFOLDER") or table.concat(names, ", ")
	end
	RefreshConfigList()
	local function PreviewFor(name)
		name = SanitizeFileName(name or "")
		if not name then return "-" end
		local content = ConfigIndex[name]
		if not content then return "-" end
		local body = string.match(content, "^(.-)||") or content
		local n = 0
		for _ in string.gmatch(body, "[^;]+") do n += 1 end
		return name .. ".cfg  (" .. n .. " keys)"
	end

	local LogReport = 0
	local function RenderLog()
		local box = Widgets.log
		if not box then return end
		for _, c in ipairs(box:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
		LogReport += 1
		local lines, errs = DebugLog.Report()
		local order = 0
		local function add(text, color)
			order += 1
			New("TextLabel", box, {Size = UDim2.new(1,0,0,16), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = text, TextColor3 = color,
				Font = CODE, TextSize = 11, TextWrapped = true, TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = order})
		end
		add(string.format("== report #%d  %s  entries: %d  errors: %d ==", LogReport, os.date("%H:%M:%S"), #lines, errs), Theme.Accent)
		for _, l in ipairs(lines) do add(l.text, l.err and Color3.fromRGB(255,110,110) or Theme.SubText) end
	end

	local function Sec(l) return {t = "section", l = l} end
	local function Tog(l, k) return {t = "toggle", l = l, k = k} end
	local function Sld(l, k, mn, mx, d) return {t = "slider", l = l, k = k, min = mn, max = mx, dec = d} end
	local function Cho(l, k, opts) return {t = "choice", l = l, k = k, opts = opts} end
	local function ChoX(l, opts, get, set) return {t = "choice", l = l, opts = opts, get = get, set = set} end
	local function Bnd(l, k) return {t = "bind", l = l, k = k} end
	local function Act(l, fn) return {t = "action", l = l, fn = fn} end
	local function Inp(id, ph, h, multi) return {t = "input", id = id, ph = ph, h = h, multi = multi} end
	local function Inf(l, fn) return {t = "info", l = l, fn = fn} end
	local function Lab(l) return {t = "label", l = l} end
	local function Log() return {t = "log"} end
	local function Avt() return {t = "avatar"} end
	local function ColorSld(key, ch)
		local idx = ({R = 1, G = 2, B = 3})[ch]
		return {t = "slider", raw = key .. " " .. ch, min = 0, max = 255, dec = 0,
			get = function() local c = Themes.Custom[key]; return math.floor(({c.R, c.G, c.B})[idx] * 255 + 0.5) end,
			set = function(v)
				local c = Themes.Custom[key]
				local r, g, b = c.R * 255, c.G * 255, c.B * 255
				if idx == 1 then r = v elseif idx == 2 then g = v else b = v end
				Themes.Custom[key] = Color3.fromRGB(math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
				if Prefs.Theme == "Custom" then ApplyTheme() end
			end}
	end
	local function Fmt2(sec)
		sec = math.floor(sec)
		return string.format("%02d:%02d:%02d", math.floor(sec / 3600), math.floor((sec % 3600) / 60), sec % 60)
	end

	local Spec = {}
	local function Tab(key, loc, items) table.insert(Spec, {Key = key, Locale = loc, Items = items}) end

	Tab("AIMBOT", "TAB_AIMBOT", {
		Sec("SEC_AIMBOT"), Tog("OPT_AIMBOT","AimbotEnabled"), Tog("OPT_HOLD_RMB","AimHold"), Tog("OPT_TEAMCHECK","AimTeamCheck"), Tog("OPT_IGNOREBOT","AimIgnoreBots"), Tog("OPT_VISIBLECHECK","VisibleCheck"),
		Cho("OPT_AIMPART","AimPart",{"Head","Chest","Root"}), Sld("OPT_AIMSPEED","AimSpeed",1,60,0), Sld("OPT_FOVRADIUS","FOVRadius",20,500,0),
		Sld("OPT_MAXDIST","MaxAimDistance",100,5000,0), Tog("OPT_PREDICTION","PredictionEnabled"), Sld("OPT_PREDICTIONTIME","PredictionTime",0.02,0.4,2),
		Tog("OPT_SHOWFOV","ShowFOV"), Tog("OPT_TARGETLINE","ShowTargetLine"),
		Sec("SEC_TRIGGER"), Tog("OPT_TRIGGERBOT","TriggerEnabled"), Sld("OPT_TRIGGERFOV","TriggerFOV",1,100,0), Tog("OPT_SHOWTRIGGERFOV","ShowTriggerFOV"),
		Tog("OPT_HITBOX","TriggerHitbox"), Cho("OPT_TRIGGERPART","TriggerPart",{"Head","Body","Any"}), Tog("OPT_TEAMCHECK","TriggerTeamCheck"), Tog("OPT_IGNOREBOT","TriggerIgnoreBots"),
		Tog("OPT_WALLCHECK","TriggerWallCheck"), Tog("OPT_ONLYAIM","TriggerOnlyAim"), Sld("OPT_MAXDIST","TriggerMaxDistance",50,3000,0),
		Sld("OPT_REACTDELAY","TriggerDelay",0,0.5,2), Sld("OPT_FIREINTERVAL","TriggerInterval",0.02,0.6,2), Tog("OPT_HUMANIZE","TriggerHumanize"),
		Cho("OPT_CLICKMODE","TriggerClickMode",{"Auto","Tool"}),
	})
	Tab("VISUALS", "TAB_VISUALS", {
		Sec("SEC_ESP"), Tog("OPT_ESP","ESPEnabled"), Tog("OPT_HIDETEAM","ESPTeamCheck"), Tog("OPT_IGNOREBOT","ESPIgnoreBots"), Tog("OPT_BOXES","ShowBoxes"), Tog("OPT_CORNERBOXES","CornerBoxEnabled"),
		Tog("OPT_NAMES","ShowNames"), Tog("OPT_DISTANCE","ShowDistance"), Tog("OPT_HEALTHBAR","ShowHealth"), Tog("OPT_SKELETON","ShowSkeleton"),
		Tog("OPT_HEADDOT","ShowHeadDot"), Tog("OPT_WEAPON","ShowWeapon"), Tog("OPT_OFFSCREEN","ShowOffscreen"), Tog("OPT_CHAMS","ChamsEnabled"),
		Tog("OPT_TRACERS","ShowTracers"), Cho("OPT_TRACERORIGIN","TracerOrigin",TracerOriginNames), Cho("OPT_ESPCOLOR","ESPColor",ESPColorNames),
		Sld("OPT_ESPDIST","ESPMaxDistance",100,5000,0),
	})
	Tab("MOVEMENT", "TAB_MOVEMENT", {
		Sec("SEC_MOVEMENT"), Tog("OPT_SPEED","SpeedEnabled"), Sld("OPT_WALKSPEED","SpeedValue",16,250,0), Tog("OPT_JUMPPOWER","JumpEnabled"),
		Sld("OPT_JUMPVALUE","JumpValue",50,300,0), Tog("OPT_FLY","FlyEnabled"), Sld("OPT_FLYSPEED","FlySpeed",20,300,0), Tog("OPT_NOCLIP","NoclipEnabled"),
		Tog("OPT_INFJUMP","InfJumpEnabled"),
	})
	Tab("PRESETS", "TAB_PRESETS", {
		Sec("SEC_PRESETS"), Cho("OPT_SCENEPRESET","WorldPreset",PresetNames),
	})
	Tab("RENDERING", "TAB_RENDERING", {
		Sec("SEC_RENDERING"), Tog("OPT_FULLBRIGHT","FullBrightEnabled"), Tog("OPT_NOSHADOWS","NoShadowsEnabled"), Tog("OPT_EXPOSURE","ExposureEnabled"),
		Sld("OPT_EXPOSUREVAL","Exposure",-3,3,1), Tog("OPT_HIDECLOUDS","HideCloudsEnabled"), Tog("OPT_GRAVITY","GravityEnabled"),
		Sld("OPT_GRAVITYVAL","GravityValue",10,400,0), Tog("OPT_HUD","HUDEnabled"),
		Sec("SEC_TIME"), Tog("OPT_FORCETIME","TimeOfDayEnabled"), Sld("OPT_TIMEOFDAY","TimeOfDay",0,24,1), Tog("OPT_TIMEFLOW","TimeFlowEnabled"),
		Sld("OPT_FLOWSPEED","TimeFlowSpeed",0.02,3,2),
		Sec("SEC_POSTFX"), Tog("OPT_GLOW","GlowEnabled"), Sld("OPT_GLOWINT","GlowIntensity",0,1,2), Sld("OPT_GLOWSIZE","GlowSize",1,56,0), Tog("OPT_COLORGRADE","ColorGradeEnabled"),
		Sld("OPT_SATURATION","ColorSaturation",-1,1,2), Sld("OPT_CONTRAST","ColorContrast",-1,1,2), Sld("OPT_BRIGHTNESS","ColorBrightness",-1,1,2),
		Cho("OPT_TINT","ColorTintName",WorldTintNames), Cho("OPT_VISIONMODE","VisionMode",VisionNames),
		Tog("OPT_DOF","DOFEnabled"), Sld("OPT_FOCUSDIST","DOFFocus",5,500,0), Sld("OPT_BLURAMOUNT","DOFFar",0,1,2), Sld("OPT_NEARBLUR","DOFNear",0,1,2), Sld("OPT_FOCUSRADIUS","DOFRadius",5,200,0),
		Tog("OPT_SCREENBLUR","BlurEnabled"), Sld("OPT_BLURSIZE","BlurSize",0,40,0), Tog("OPT_VIGNETTE","VignetteEnabled"), Sld("OPT_VIGNETTEINT","VignetteIntensity",0,1,2),
		Sec("SEC_AMBIENT"), Tog("OPT_AMBIENT","AmbientEnabled"), Cho("OPT_AMBIENTCOLOR","AmbientColorName",WorldTintNames), Sld("OPT_AMBIENTINT","AmbientIntensity",0,1,2),
		Sec("SEC_SKY"), Tog("OPT_STARS","StarsEnabled"), Sld("OPT_STARCOUNT","StarCount",500,10000,0),
	})
	Tab("CAMERA", "TAB_CAMERA", {
		Sec("SEC_CAMERA"), Tog("OPT_CUSTOMFOV","CustomFOVEnabled"), Sld("OPT_CAMERAFOV","CameraFOV",30,120,0), Tog("OPT_HOLDZOOM","ZoomEnabled"),
		Sld("OPT_ZOOMFOV","ZoomFOV",5,60,0), Tog("OPT_FREECAM","FreecamEnabled"), Sld("OPT_FREECAMSPEED","FreecamSpeed",10,300,0),
		Tog("OPT_ZOOMLIMIT","ZoomLimitEnabled"), Sld("OPT_MAXZOOM","ZoomLimit",10,500,0),
	})
	Tab("WEATHER", "TAB_WEATHER", {
		Sec("SEC_WEATHER"), Tog("OPT_SNOW","SnowEnabled"), Sld("OPT_SNOWDENSITY","SnowIntensity",5,150,0), Tog("OPT_RAIN","RainEnabled"),
		Sld("OPT_RAINDENSITY","RainIntensity",5,200,0), Sld("OPT_WIND","WindStrength",0,30,0), Tog("OPT_FOG","FogEnabled"), Sld("OPT_FOGDIST","FogDensity",30,800,0),
		Cho("OPT_FOGCOLOR","FogColorName",FogColorNames), Tog("OPT_LIGHTNING","LightningEnabled"), Sld("OPT_LIGHTNINGINT","LightningInterval",2,30,0),
		Sec("SEC_ATMOSPHERE"), Tog("OPT_ATMOSPHERE","AtmosphereEnabled"), Sld("OPT_ATMODENSITY","AtmoDensity",0,1,2), Sld("OPT_ATMOHAZE","AtmoHaze",0,10,1),
		Cho("OPT_ATMOCOLOR","AtmoColorName",FogColorNames), Tog("OPT_SUNRAYS","SunRaysEnabled"), Sld("OPT_RAYSINT","SunRaysIntensity",0,1,2),
		Sld("OPT_RAYSSPREAD","SunRaysSpread",0,1,2), Tog("OPT_RAINBOW","RainbowEnabled"), Sld("OPT_RAINBOWSPEED","RainbowSpeed",0.02,1,2),
		Sec("SEC_PARTICLES"), Tog("OPT_ASH","AshEnabled"), Sld("OPT_ASHINT","AshIntensity",5,150,0),
	})
	Tab("CROSSHAIR", "TAB_CROSSHAIR", {
		Sec("SEC_CROSSHAIR"), Tog("OPT_CUSTOMCROSS","CrosshairEnabled"), Sld("OPT_CROSSSIZE","CrosshairSize",2,30,0), Sld("OPT_CROSSGAP","CrosshairGap",0,20,0),
		Sld("OPT_CROSSTHICK","CrosshairThickness",1,6,0), Tog("OPT_CENTERDOT","CrosshairDot"), Cho("OPT_CROSSCOLOR","CrosshairColorName",CrosshairColorNames),
		Tog("OPT_SPIN","CrosshairSpin"), Tog("OPT_DYNAMICGAP","CrosshairDynamic"), Tog("OPT_REDONTARGET","CrosshairReactive"),
		Sec("SEC_HITFX"), Tog("OPT_HITMARKER","HitMarkerEnabled"), Tog("OPT_HITSOUND","HitSoundEnabled"),
		Cho("OPT_HITSTYLE","HitMarkerStyle",HitMarkerStyles), Cho("OPT_HITEFFECT","HitEffect",HitEffects), Sld("OPT_HITSIZE","HitMarkerSize",0.5,2.5,1), Sld("OPT_HITTIME","HitMarkerLifetime",0.12,1.2,2),
	})
	Tab("PROFILE", "TAB_PROFILE", {
		Sec("SEC_ACCOUNT"), Avt(),
		Inf("LBL_USERNAME", function() return LocalPlayer.Name end), Inf("LBL_DISPLAYNAME", function() return LocalPlayer.DisplayName end),
		Inf("LBL_USERID", function() return tostring(LocalPlayer.UserId) end),
		Inf("LBL_ACCOUNTAGE", function() return LocalPlayer.AccountAge .. " " .. Locale.T("LBL_DAYS") end),
		Sec("SEC_SESSION"), Inf("LBL_SESSIONTIME", function() return Fmt2(os.clock() - SessionStart) end),
		Inf("LBL_TEAM", function() local t = LocalPlayer.Team; return t and t.Name or Locale.T("LBL_NOTEAM") end),
		Inf("LBL_HEALTH", function() local h = GetHumanoid(); return h and string.format("%d / %d", math.max(math.floor(h.Health), 0), math.floor(h.MaxHealth)) or "-" end),
		Inf("LBL_CHARSTATE", function() local h = GetHumanoid(); if not h then return Locale.T("LBL_NOCHAR") end; return h.Health > 0 and Locale.T("LBL_ALIVE") or Locale.T("LBL_DEAD") end),
		Sec("SEC_SERVER"), Inf("LBL_PLACEID", function() return tostring(game.PlaceId) end),
		Inf("LBL_JOBID", function() return game.JobId ~= "" and game.JobId or "Studio" end),
		Inf("LBL_PLAYERCOUNT", function() return tostring(#Players:GetPlayers()) end), Inf("LBL_PING", function() return GetPing() .. " ms" end),
	})
	Tab("DEBUG", "TAB_DEBUG", {
		Sec("SEC_LOG"),
		Act("BTN_REFRESHLOG", function() RenderLog(); Notify(Locale.T("TOAST_LOGREFRESH")) end),
		Act("BTN_CLEARLOG", function() DebugLog.Clear(); RenderLog() end),
		Log(),
	})
	local bindItems = {Sec("SEC_SCRIPT"), Bnd("MENU_KEY", "Menu")}
	for _, k in ipairs(BindOrder) do table.insert(bindItems, Bnd(BindNameKeys[k], k)) end
	table.insert(bindItems, Bnd("BIND_ZOOM", "Zoom"))
	Tab("BINDS", "TAB_BINDS", bindItems)

	local Unload
	local function SetMenu(state)
		if MenuState.Open == state then return end
		MenuState.Open = state
		if Skin then Skin.Show(state) end
	end

	local st = {
		Sec("SEC_INTERFACE"),
		Inf("LBL_ERRORSTATUS", function()
			local _, errs = DebugLog.Report()
			return errs > 0 and (tostring(errs) .. " errors logged") or "clean"
		end),
		ChoX("OPT_THEME", ThemeNames, function() return Prefs.Theme end, function(v) Prefs.Theme = v; ApplyTheme() end),
		ChoX("OPT_ACCENT", AccentNames, function() return Prefs.Accent end, function(v) Prefs.Accent = v; ApplyTheme() end),
		Sld("OPT_MENUSCALE", "UIScale", 0.7, 1.3, 2), Sld("OPT_MENUTRANSP", "UIOpacity", 0, 0.5, 2),
		Sec("SEC_LANGUAGE"), ChoX("OPT_LANGUAGE", LanguageCodes, function() return Locale.Current end, function(v) Locale.SetLanguage(v, Notify) end),
		Sec("SEC_THEME"),
	}
	for _, key in ipairs(ThemeKeys) do for _, ch in ipairs({"R","G","B"}) do table.insert(st, ColorSld(key, ch)) end end
	for _, it in ipairs({
		Act("BTN_RESETCOLORS", function()
			for k, v in pairs(Themes.Obsidian) do Themes.Custom[k] = v end
			ApplyTheme()
		end),
		Sec("SEC_CONFIG"), Lab("LBL_CONFIGNAME"), Inp("cfgName", "PH_CONFIGNAME", 40, false), Lab("LBL_CONFIGSTRING"), Inp("cfgBox", "PH_CONFIGSTRING", 70, true),
		Act("BTN_EXPORT", function() Widgets.cfgBox.Text = SerializeConfig(); Notify(Locale.T("TOAST_EXPORTED")) end),
		Act("BTN_IMPORT", function()
			local ok, n = pcall(DeserializeConfig, Widgets.cfgBox.Text)
			if not ok then DebugLog.Push("config", tostring(n), true) end
			if ok and n and n > 0 then Notify(string.format(Locale.T("TOAST_IMPORTED"), n)) else Notify(Locale.T("TOAST_IMPORTFAIL")) end
		end),
		Act("BTN_SAVE", function()
			local name = SanitizeFileName(Widgets.cfgName.Text)
			if not name or not EnsureFolder() then Notify(Locale.T("TOAST_SAVEFAIL")); return end
			local ok = pcall(function() writefile(CONFIG_FOLDER .. "/" .. name .. ".cfg", SerializeConfig()) end)
			Notify(ok and string.format(Locale.T("TOAST_SAVED"), name) or Locale.T("TOAST_SAVEFAIL"))
			RefreshConfigList()
		end),
		Act("BTN_LOAD", function()
			local name = SanitizeFileName(Widgets.cfgName.Text)
			if not name then Notify(Locale.T("TOAST_LOADFAIL")); return end
			local content = ConfigIndex[name]
			if not content then
				local ok, c2 = pcall(function()
					local path = CONFIG_FOLDER .. "/" .. name .. ".cfg"
					if not isfile(path) then error("missing") end
					return readfile(path)
				end)
				if not ok then Notify(Locale.T("TOAST_LOADFAIL")); return end
				content = c2
			end
			local ok2, n = pcall(DeserializeConfig, content)
			if ok2 and n and n > 0 then Notify(string.format(Locale.T("TOAST_LOADED_FILE"), name, n)) else Notify(Locale.T("TOAST_IMPORTFAIL")) end
		end),
		Inf("LBL_SAVEDCONFIGS", function() return ConfigListText end),
		Inf("LBL_CONFIGPREVIEW", function() return PreviewFor(Widgets.cfgName and Widgets.cfgName.Text) end),
		Act("BTN_REFRESH", function() RefreshConfigList(); Notify(Locale.T("TOAST_LOGREFRESH")) end),
		Act("BTN_RESET", function() for k, v in pairs(Defaults) do SetValue(k, v) end; Notify(Locale.T("TOAST_DEFAULTS")) end),
		Sec("SEC_SCRIPT"), Act("BTN_UNLOAD", function() Unload() end),
	}) do table.insert(st, it) end
	Tab("SETTINGS", "TAB_SETTINGS", st)

	do
		local function harvest(items)
			for _, it in ipairs(items) do
				if it.t == "slider" and it.k and it.min and it.max then
					ClampTable[it.k] = {min = it.min, max = it.max}
				end
			end
		end
		for _, tab in ipairs(Spec) do harvest(tab.Items) end
		harvest(st)
	end

	local function Lbl(parent, it, props)
		props.BackgroundTransparency = 1
		local t = New("TextLabel", parent, props)
		if it.raw then t.Text = it.raw else Locale.Bind(t, it.l) end
		return t
	end
	local function ToggleLogic(it, btn, paint)
		Connect(btn.MouseButton1Click, function() SetValue(it.k, not S[it.k]) end)
		Watch(it.k, function() paint(S[it.k]) end, true)
	end
	local function ChoiceLogic(it, btn, paint)
		local get = it.get or function() return S[it.k] end
		local set = it.set or function(v) SetValue(it.k, v) end
		local function show() paint(tostring(get())) end
		local function step(d)
			local i = table.find(it.opts, get()) or 1
			set(it.opts[(i - 1 + d) % #it.opts + 1])
			show()
		end
		Connect(btn.MouseButton1Click, function() step(1) end)
		Connect(btn.MouseButton2Click, function() step(-1) end)
		Watch(it.k, show, true)
	end
	local ColorSwatchKeys = {ESPColor = true, CrosshairColorName = true, ColorTintName = true, AmbientColorName = true, FogColorName = true, AtmoColorName = true}
	local ColorSwatchLookup = {ESPColor = ESPColors, CrosshairColorName = ESPColors, ColorTintName = WorldTintColors, AmbientColorName = WorldTintColors,
		FogColorName = WorldTintColors, AtmoColorName = WorldTintColors}
	local function ResolveSwatchColor(key)
		local name = S[key]
		if name == nil then return nil end
		if name == "Theme" then return Theme.Accent end
		local table_ = ColorSwatchLookup[key]
		if not table_ then return nil end
		return table_[name]
	end
	local function AttachColorSwatch(it, parent, size)
		if not it.k or not ColorSwatchKeys[it.k] then return nil end
		local dot = Round(New("Frame", parent, {AnchorPoint = Vector2.new(1,0.5), Size = UDim2.fromOffset(size, size), BorderSizePixel = 0, ZIndex = 3}), 100)
		New("UIStroke", dot, {Color = "@Border", Thickness = 1})
		Watch(it.k, function()
			local c = ResolveSwatchColor(it.k)
			if c then dot.BackgroundColor3 = c; dot.Visible = true else dot.Visible = false end
		end, true)
		return dot
	end
	local function SliderLogic(it, hit, track, paint)
		local get = it.get or function() return S[it.k] end
		local function show()
			local v = get()
			paint(math.clamp((v - it.min) / (it.max - it.min), 0, 1), Fmt(v, it.dec))
		end
		local function fromX(x)
			local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			local m = 10 ^ it.dec
			local v = math.floor((it.min + (it.max - it.min) * a) * m + 0.5) / m
			if it.set then it.set(v) else SetValue(it.k, v) end
			show()
		end
		Connect(hit.InputBegan, function(i) if IsPointer(i) then Drag.Fn = fromX; fromX(i.Position.X) end end)
		Watch(it.k, show, true)
	end
	local function BindLogic(it, btn, show)
		Connect(btn.MouseButton1Click, function()
			if Listening then Listening.Show(KeyName(K[Listening.Key])) end
			Listening = {Key = it.k, Show = show}
			show("...")
		end)
		show(KeyName(K[it.k]))
	end
	local function Draggable(handle, target)
		Connect(handle.InputBegan, function(i)
			if not IsPointer(i) then return end
			local s0 = Vector2.new(i.Position.X, i.Position.Y)
			local p0 = target.Position
			Drag.Move = function(pos)
				local d = Vector2.new(pos.X, pos.Y) - s0
				target.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
			end
		end)
	end
	local function MakeAvatar(parent, px)
		local img = Round(New("ImageLabel", parent, {Size = UDim2.fromOffset(px, px), BackgroundColor3 = "@Background", BorderSizePixel = 0, ScaleType = Enum.ScaleType.Crop}), 10)
		task.spawn(function()
			local ok, content, ready = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
			if ok and ready and img.Parent then img.Image = content end
		end)
		return img
	end
	local function InfoReg(label, it)
		table.insert(Infos, {Label = label, fn = it.fn})
		local ok, v = pcall(it.fn)
		label.Text = ok and v or "-"
	end
	local function BuildTab(tab, page, C)
		local ctx = {page = page, n = 0}
		for _, it in ipairs(tab.Items) do C[it.t](it, ctx) end
		if C.__finish then C.__finish(ctx) end
	end

	local function StandardShow(root, scale, state)
		if state then
			root.Visible = true
			Tween(scale, {Scale = S.UIScale}, 0.32, Enum.EasingStyle.Back)
			Tween(root, {GroupTransparency = S.UIOpacity}, 0.22)
		else
			Tween(scale, {Scale = S.UIScale * 0.94}, 0.2)
			Tween(root, {GroupTransparency = 1}, 0.2)
			task.delay(0.22, function() if not MenuState.Open and root.Parent then root.Visible = false end end)
		end
	end
	local function MakeInput(parent, it, props)
		local base = {Text = "", PlaceholderColor3 = "@Muted", TextColor3 = "@Text", Font = CODE, TextSize = 11, ClearTextOnFocus = false,
			MultiLine = it.multi == true, TextWrapped = it.multi == true, TextXAlignment = LEFT,
			TextYAlignment = it.multi and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center}
		for k, v in pairs(props) do base[k] = v end
		local box = New("TextBox", parent, base)
		Locale.Bind(box, it.ph, "PlaceholderText")
		Widgets[it.id] = box
		return box
	end

	Skins.Classic = function()
		local Root = New("CanvasGroup", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(760,480),
			BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1, Visible = false})
		local Scale = New("UIScale", Root, {Scale = 0.9})
		Round(Root, 12)
		local glow = GlowStroke(Root)
		local Top = New("Frame", Root, {Size = UDim2.new(1,0,0,48), BackgroundColor3 = "@Secondary", BorderSizePixel = 0, ZIndex = 3})
		New("Frame", Top, {Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,-1), BackgroundColor3 = "@Border", BorderSizePixel = 0, ZIndex = 3})
		Locale.Bind(New("TextLabel", Top, {Position = UDim2.fromOffset(18,6), Size = UDim2.fromOffset(240,22), BackgroundTransparency = 1, TextColor3 = "@Text",
			Font = GOTHB, TextSize = 17, TextXAlignment = LEFT, ZIndex = 4}), "APP_NAME")
		local sub = New("TextLabel", Top, {Position = UDim2.fromOffset(18,27), Size = UDim2.fromOffset(340,14), BackgroundTransparency = 1, TextColor3 = "@Muted",
			Font = GOTHM, TextSize = 9, TextXAlignment = LEFT, ZIndex = 4})
		local function PaintSub() sub.Text = Locale.T("APP_SUB") .. "  |  " .. string.upper(LocalPlayer.Name) end
		PaintSub(); Locale.OnChange(PaintSub)
		local function TopBtn(text, color, x, cb)
			local b = Round(New("TextButton", Top, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,x,0.5,0), Size = UDim2.fromOffset(28,28), BackgroundColor3 = "@Row",
				Text = text, TextColor3 = color, Font = GOTHB, TextSize = 14, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 4}), 7)
			Connect(b.MouseEnter, function() Tween(b, {BackgroundColor3 = Theme.Border}, 0.12) end)
			Connect(b.MouseLeave, function() Tween(b, {BackgroundColor3 = Theme.Row}, 0.12) end)
			Connect(b.MouseButton1Click, cb)
		end
		TopBtn("X", Color3.fromRGB(255,90,100), -46, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		TopBtn("-", Theme.Text, -12, function() SetMenu(false) end)
		Draggable(Top, Root)

		local Side = New("Frame", Root, {Position = UDim2.fromOffset(0,48), Size = UDim2.fromOffset(160,432), BackgroundColor3 = "@Secondary", BorderSizePixel = 0, ZIndex = 2})
		New("Frame", Side, {Size = UDim2.new(0,1,1,0), Position = UDim2.new(1,-1,0,0), BackgroundColor3 = "@Border", BorderSizePixel = 0, ZIndex = 2})
		local List = New("ScrollingFrame", Side, {Size = UDim2.new(1,0,1,-30), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
		New("UIListLayout", List, {Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", List, {PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,6)})
		local hint = New("TextLabel", Side, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,14,1,-10), Size = UDim2.new(1,-28,0,14), BackgroundTransparency = 1,
			TextColor3 = "@Muted", Font = GOTHM, TextSize = 9, TextXAlignment = LEFT, ZIndex = 4})
		local function PaintHint() hint.Text = Locale.T("MENU_KEY") .. "  " .. KeyName(K.Menu) end
		PaintHint(); Locale.OnChange(PaintHint); table.insert(OnBind, PaintHint)
		local Content = New("Frame", Root, {Position = UDim2.fromOffset(160,48), Size = UDim2.new(1,-160,1,-48), BackgroundTransparency = 1, ClipsDescendants = true})

		local Pages, Btns, Active = {}, {}, nil
		local function Select(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, b in pairs(Btns) do
				Tween(b.Bg, {BackgroundTransparency = n == name and 0 or 1}, 0.15)
				b.Bar.Visible = n == name
				Tween(b.Label, {TextColor3 = n == name and Theme.Text or Theme.SubText}, 0.15)
			end
		end
		table.insert(Refreshers, function() if Active then Select(Active) end end)

		local C = {}
		local function row(c, h, click)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			Round(r, 8)
			local s = New("UIStroke", r, {Color = "@Border", Thickness = 1, Transparency = 0.3})
			Connect(r.MouseEnter, function() Tween(s, {Color = Theme.Accent, Transparency = 0.5}, 0.15) end)
			Connect(r.MouseLeave, function() Tween(s, {Color = Theme.Border, Transparency = 0.3}, 0.15) end)
			return r
		end
		local function rl(r, it, w) return Lbl(r, it, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,w or -170,1,0), TextColor3 = "@Text", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT}) end
		function C.section(it, c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			Round(New("Frame", h, {Size = UDim2.fromOffset(3,12), Position = UDim2.fromOffset(2,5), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 2)
			Lbl(h, it, {Position = UDim2.fromOffset(12,0), Size = UDim2.new(1,-28,1,0), TextColor3 = "@SubText", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-4,0.5,0), Size = UDim2.fromOffset(16,16), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Muted", Font = GOTHB, TextSize = 10})
			c.n += 1
			local group = New("Frame", c.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = c.n})
			New("UIListLayout", group, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			c.group, c.gn = group, 1
			CollapseOnScroll(h, group, chevron)
		end
		function C.label(it, c)
			c.n += 1
			local parent = c.group or c.page
			local h = New("Frame", parent, {Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			Lbl(h, it, {Position = UDim2.fromOffset(2,0), Size = UDim2.new(1,-4,1,0), TextColor3 = "@SubText", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
		end
		function C.toggle(it, c)
			local r = row(c, 40, true); rl(r, it, -70)
			local track = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(40,20), BorderSizePixel = 0}), 100)
			local ts = New("UIStroke", track, {Thickness = 1})
			local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(14,14), BorderSizePixel = 0}), 100)
			ToggleLogic(it, r, function(on)
				Tween(track, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.2)
				Tween(ts, {Color = on and Theme.Accent or Theme.Border}, 0.2)
				Tween(knob, {Position = on and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.Background or Theme.Muted}, 0.2)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 54)
			Lbl(r, it, {Position = UDim2.fromOffset(14,8), Size = UDim2.new(1,-110,0,16), TextColor3 = "@Text", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,8), Size = UDim2.fromOffset(90,16), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = GOTHB, TextSize = 11, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(14,38), Size = UDim2.new(1,-28,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 100)
			local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.fromOffset(12,12), BackgroundColor3 = "@Text", BorderSizePixel = 0, ZIndex = 3}), 100)
			SliderLogic(it, r, track, function(a, txt)
				Tween(fill, {Size = UDim2.fromScale(a,1)}, 0.08); Tween(knob, {Position = UDim2.fromScale(a,0.5)}, 0.08); val.Text = txt
			end)
		end
		local function sideBtn(r)
			local b = Round(New("TextButton", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(130,26), BackgroundColor3 = "@Background",
				Text = "", TextColor3 = "@Text", Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			New("UIStroke", b, {Color = "@Border", Thickness = 1})
			return b
		end
		function C.choice(it, c)
			local r = row(c, 40); rl(r, it); local b = sideBtn(r)
			ChoiceLogic(it, b, function(t) b.Text = t end)
		end
		function C.bind(it, c)
			local r = row(c, 40); rl(r, it); local b = sideBtn(r)
			BindLogic(it, b, function(t) b.Text = t end)
		end
		function C.action(it, c)
			local r = row(c, 40)
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-24,0,28), BackgroundColor3 = "@Accent", TextColor3 = "@Background",
				Font = GOTHB, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Connect(b.MouseEnter, function() Tween(b, {BackgroundTransparency = 0.2}, 0.12) end)
			Connect(b.MouseLeave, function() Tween(b, {BackgroundTransparency = 0}, 0.12) end)
			Connect(b.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = row(c, it.h)
			local box = Round(MakeInput(r, it, {Position = UDim2.fromOffset(14,8), Size = UDim2.new(1,-28,1,-16), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 6)
			New("UIStroke", box, {Color = "@Border", Thickness = 1})
			New("UIPadding", box, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
		end
		function C.info(it, c)
			local r = row(c, 40); rl(r, it, -300)
			local v = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(280,20), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = GOTHB, TextSize = 12, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.log(it, c)
			local r = row(c, 340)
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(10,10), Size = UDim2.new(1,-20,1,-20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = row(c, 96)
			local img = MakeAvatar(r, 72); img.Position = UDim2.fromOffset(12,12)
			New("TextLabel", r, {Position = UDim2.fromOffset(94,30), Size = UDim2.new(1,-110,0,24), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = "@Text", Font = GOTHB, TextSize = 16, TextXAlignment = LEFT})
			New("TextLabel", r, {Position = UDim2.fromOffset(94,54), Size = UDim2.new(1,-110,0,16), BackgroundTransparency = 1, Text = "@" .. LocalPlayer.DisplayName, TextColor3 = "@SubText", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
		end

		for i, tab in ipairs(Spec) do
			local page = New("ScrollingFrame", Content, {Name = tab.Key, Position = UDim2.fromOffset(10,10), Size = UDim2.new(1,-20,1,-20), BackgroundTransparency = 1, BorderSizePixel = 0,
				ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false})
			New("UIListLayout", page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			New("UIPadding", page, {PaddingRight = UDim.new(0,8), PaddingBottom = UDim.new(0,10)})
			Pages[tab.Key] = page
			local b = Round(New("TextButton", List, {Size = UDim2.fromOffset(144,36), BackgroundColor3 = "@Row", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i}), 8)
			local bar = Round(New("Frame", b, {Position = UDim2.fromOffset(0,8), Size = UDim2.fromOffset(3,20), BackgroundColor3 = "@Accent", BorderSizePixel = 0, Visible = false}), 2)
			local lab = New("TextLabel", b, {Position = UDim2.fromOffset(16,0), Size = UDim2.new(1,-16,1,0), BackgroundTransparency = 1, TextColor3 = Theme.SubText, Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
			Locale.Bind(lab, tab.Locale)
			Btns[tab.Key] = {Bg = b, Bar = bar, Label = lab}
			Connect(b.MouseButton1Click, function() Select(tab.Key) end)
			BuildTab(tab, page, C)
		end
		Select(Spec[1].Key)
		return {
			Show = function(state) StandardShow(Root, Scale, state) end,
			Scale = function(v) if MenuState.Open then Tween(Scale, {Scale = v}, 0.1) end end,
			Opacity = function(v) if MenuState.Open then Tween(Root, {GroupTransparency = v}, 0.1) end end,
			Destroy = function() glow:Cancel() end,
		}
	end

	Skins.Windows = function()
		local Holder = New("Frame", MenuGui, {Name = "Main", Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Visible = false})
		local Wins = {}
		local function P(t)
			local n = {BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTH, TextSize = 11, TextXAlignment = LEFT}
			for k, v in pairs(t) do n[k] = v end
			return n
		end
		local C = {}
		local function row(c, h, click, color)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,-8,0,h), BackgroundColor3 = color or "@Row", BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			return Round(r, 5)
		end
		function C.section(it, c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,-8,0,20), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			Lbl(h, it, P{Size = UDim2.new(1,-16,1,-3), TextColor3 = "@Accent", Font = GOTHB, TextSize = 10})
			New("Frame", h, {Position = UDim2.new(0,0,1,-2), Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,-3), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Accent", Font = GOTHB, TextSize = 9})
			c.n += 1
			local group = New("Frame", c.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = c.n})
			New("UIListLayout", group, {Padding = UDim.new(0,3), SortOrder = Enum.SortOrder.LayoutOrder})
			c.group, c.gn = group, 1
			CollapseOnScroll(h, group, chevron)
		end
		function C.label(it, c) local r = row(c, 18, false, "@Background"); Lbl(r, it, P{Size = UDim2.new(1,0,1,0), TextColor3 = "@SubText"}) end
		function C.toggle(it, c)
			local r = row(c, 26, true)
			local box = Round(New("Frame", r, {Position = UDim2.fromOffset(8,6), Size = UDim2.fromOffset(14,14), BorderSizePixel = 0}), 3)
			local s = New("UIStroke", box, {Thickness = 1})
			Lbl(r, it, P{Position = UDim2.fromOffset(30,0), Size = UDim2.new(1,-36,1,0)})
			ToggleLogic(it, r, function(on)
				Tween(box, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.15); Tween(s, {Color = on and Theme.Accent or Theme.Border}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 36)
			Lbl(r, it, P{Position = UDim2.fromOffset(8,3), Size = UDim2.new(1,-70,0,16)})
			local val = New("TextLabel", r, P{AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-8,0,3), Size = UDim2.fromOffset(60,16), TextColor3 = "@SubText", TextXAlignment = RIGHT})
			local track = New("Frame", r, {Position = UDim2.fromOffset(8,26), Size = UDim2.new(1,-16,0,3), BackgroundColor3 = "@Background", BorderSizePixel = 0})
			local fill = New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0})
			SliderLogic(it, r, track, function(a, txt) fill.Size = UDim2.fromScale(a,1); val.Text = txt end)
		end
		local function valueRow(it, c, logic)
			local r = row(c, 26, true)
			Lbl(r, it, P{Position = UDim2.fromOffset(8,0), Size = UDim2.new(0.55,-8,1,0)})
			local v = New("TextLabel", r, P{AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-8,0,0), Size = UDim2.new(0.45,-8,1,0), TextColor3 = "@Accent", Font = GOTHB, TextXAlignment = RIGHT})
			logic(it, r, function(t) v.Text = t end)
		end
		function C.choice(it, c) valueRow(it, c, ChoiceLogic) end
		function C.bind(it, c) valueRow(it, c, BindLogic) end
		function C.action(it, c)
			local r = row(c, 26, true, "@Accent")
			Lbl(r, it, P{Size = UDim2.new(1,0,1,0), TextColor3 = "@Background", Font = GOTHB, TextXAlignment = CENTER})
			Connect(r.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = row(c, it.h, false, "@Background")
			MakeInput(r, it, {Position = UDim2.fromOffset(4,4), Size = UDim2.new(1,-8,1,-8), BackgroundTransparency = 1})
			New("UIStroke", r, {Color = "@Border", Thickness = 1})
		end
		function C.info(it, c)
			local r = row(c, 26)
			Lbl(r, it, P{Position = UDim2.fromOffset(8,0), Size = UDim2.new(0.45,-8,1,0), TextColor3 = "@SubText"})
			local v = New("TextLabel", r, P{AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-8,0,0), Size = UDim2.new(0.55,-8,1,0), Font = GOTHB, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.log(it, c)
			local r = row(c, 230, false, "@Background")
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(4,4), Size = UDim2.new(1,-8,1,-8), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = row(c, 64)
			local img = MakeAvatar(r, 48); img.Position = UDim2.fromOffset(8,8)
			New("TextLabel", r, P{Position = UDim2.fromOffset(64,14), Size = UDim2.new(1,-70,0,18), Text = LocalPlayer.Name, Font = GOTHB, TextSize = 13})
			New("TextLabel", r, P{Position = UDim2.fromOffset(64,32), Size = UDim2.new(1,-70,0,16), Text = "@" .. LocalPlayer.DisplayName, TextColor3 = "@SubText"})
		end
		local cols = math.max(1, math.floor((Camera.ViewportSize.X - 16) / 246))
		for i, tab in ipairs(Spec) do
			local win = Round(New("CanvasGroup", Holder, {Position = UDim2.fromOffset(16 + ((i - 1) % cols) * 246, 16 + math.floor((i - 1) / cols) * 360), Size = UDim2.fromOffset(230,26),
				BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = S.UIOpacity}), 8)
			New("UIStroke", win, {Color = "@Border", Thickness = 1})
			local sc = New("UIScale", win, {Scale = S.UIScale})
			local bar = New("Frame", win, {Size = UDim2.new(1,0,0,26), BackgroundColor3 = "@Secondary", BorderSizePixel = 0})
			New("Frame", bar, {Position = UDim2.new(0,0,1,-2), Size = UDim2.new(1,0,0,2), BackgroundColor3 = "@Accent", BorderSizePixel = 0})
			Locale.Bind(New("TextLabel", bar, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(1,-70,1,-2), BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT}), tab.Locale)
			local arrow = New("TextButton", bar, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,0), Size = UDim2.fromOffset(28,24), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = GOTHB, TextSize = 12, Text = ">"})
			if i == 1 then
				local x = New("TextButton", bar, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-28,0,0), Size = UDim2.fromOffset(28,24), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,90,100), Font = GOTHB, TextSize = 12, Text = "X"})
				Connect(x.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
			end
			local body = New("ScrollingFrame", win, {Position = UDim2.fromOffset(0,26), Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false})
			local layout = New("UIListLayout", body, {Padding = UDim.new(0,3), SortOrder = Enum.SortOrder.LayoutOrder})
			New("UIPadding", body, {PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4)})
			local w = {Win = win, Scale = sc, Open = i <= 3}
			w.Fit = function()
				local h = math.min(layout.AbsoluteContentSize.Y / math.max(sc.Scale, 0.01) + 8, 320)
				body.Size = UDim2.new(1,0,0,h); body.Visible = w.Open
				win.Size = UDim2.fromOffset(230, 26 + (w.Open and h or 0))
				arrow.Text = w.Open and "v" or ">"
			end
			Connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"), w.Fit)
			Connect(arrow.MouseButton1Click, function() w.Open = not w.Open; w.Fit() end)
			Draggable(bar, win)
			table.insert(Wins, w)
			BuildTab(tab, body, C)
			w.Fit()
		end
		return {
			Show = function(state) Holder.Visible = state end,
			Scale = function(v) for _, w in ipairs(Wins) do w.Scale.Scale = v; w.Fit() end end,
			Opacity = function(v) for _, w in ipairs(Wins) do w.Win.GroupTransparency = v end end,
			Destroy = function() end,
		}
	end

	Skins.Dock = function()
		local Root = New("Frame", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-14), Size = UDim2.fromOffset(660,490), BackgroundTransparency = 1, Visible = false})
		local Scale = New("UIScale", Root, {Scale = S.UIScale})
		local Panel = Round(New("CanvasGroup", Root, {Size = UDim2.fromOffset(660,428), BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1}), 16)
		local glow = GlowStroke(Panel)
		local head = New("Frame", Panel, {Size = UDim2.new(1,0,0,40), BackgroundColor3 = "@Secondary", BorderSizePixel = 0})
		New("Frame", head, {Position = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
		local title = New("TextLabel", head, {Position = UDim2.fromOffset(16,0), Size = UDim2.new(1,-90,1,0), BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHB, TextSize = 13, TextXAlignment = LEFT})
		local function HeadBtn(text, color, x, cb)
			local b = Round(New("TextButton", head, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,x,0.5,0), Size = UDim2.fromOffset(26,26), BackgroundColor3 = "@Row",
				Text = text, TextColor3 = color, Font = GOTHB, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0}), 13)
			Connect(b.MouseButton1Click, cb)
		end
		HeadBtn("X", Color3.fromRGB(255,90,100), -10, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		HeadBtn("-", Theme.Text, -42, function() SetMenu(false) end)
		Draggable(head, Root)

		local Body = New("Frame", Panel, {Position = UDim2.fromOffset(0,40), Size = UDim2.new(1,0,1,-40), BackgroundTransparency = 1, ClipsDescendants = true})
		local tabCount = #Spec
		local Dock = Round(New("CanvasGroup", Root, {AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,0), Size = UDim2.fromOffset(tabCount * 84 + 20, 52),
			BackgroundColor3 = "@Secondary", BorderSizePixel = 0, GroupTransparency = 1}), 26)
		New("UIStroke", Dock, {Color = "@Border", Thickness = 1})
		local dockList = New("Frame", Dock, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1})
		New("UIListLayout", dockList, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder})

		local Pages, Btns, Active = {}, {}, nil
		local PanelOpen = true
		local function Select(name)
			if Active == name and PanelOpen then PanelOpen = false; Panel.Visible = false; Active = nil
			else
				Active = name; PanelOpen = true; Panel.Visible = true
			end
			for n, p in pairs(Pages) do p.Visible = n == Active end
			for n, b in pairs(Btns) do
				Tween(b.Btn, {BackgroundTransparency = n == Active and 0 or 1}, 0.15)
				Tween(b.Label, {TextColor3 = n == Active and Theme.Background or Theme.SubText}, 0.15)
			end
			if Active then
				for _, t in ipairs(Spec) do if t.Key == Active then Locale.Bind(title, t.Locale) end end
			end
		end
		table.insert(Refreshers, function()
			for n, b in pairs(Btns) do b.Label.TextColor3 = n == Active and Theme.Background or Theme.SubText end
		end)

		local C = {}
		local FULL, HALF = 1, 0.5
		local function tile(c, h, w, click, color)
			c.n += 1
			local size = w == HALF and UDim2.new(0.5,-4,0,h) or UDim2.new(1,0,0,h)
			local r = New(click and "TextButton" or "Frame", c.page, {Size = size, BackgroundColor3 = color or "@Row", BorderSizePixel = 0, LayoutOrder = c.n})
			if click then r.Text = ""; r.AutoButtonColor = false end
			Round(r, 10)
			if c.sectionTiles then table.insert(c.sectionTiles, r) end
			return r
		end
		local function tl(r, it, props)
			local base = {BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd}
			for k, v in pairs(props) do base[k] = v end
			return Lbl(r, it, base)
		end
		local function WireSection(c)
			if not (c.sectionHeader and c.sectionTiles) then return end
			local header, tiles, chevron = c.sectionHeader, c.sectionTiles, c.sectionChevron
			local collapsed = false
			local hovering = false
			local function Paint()
				for _, t in ipairs(tiles) do t.Visible = not collapsed end
				if chevron then Tween(chevron, {Rotation = collapsed and -90 or 0}, 0.15) end
			end
			Connect(header.MouseEnter, function() hovering = true end)
			Connect(header.MouseLeave, function() hovering = false end)
			Connect(UserInputService.InputChanged, function(input)
				if not hovering or input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
				local up = input.Position.Z > 0
				if up and not collapsed then collapsed = true; Paint()
				elseif (not up) and collapsed then collapsed = false; Paint() end
			end)
			c.sectionHeader, c.sectionChevron, c.sectionTiles = nil, nil, nil
		end
		function C.section(it, c)
			WireSection(c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			tl(h, it, {Size = UDim2.new(1,-20,1,-6), TextColor3 = "@Accent", Font = GOTHB, TextSize = 11})
			New("Frame", h, {Position = UDim2.new(0,0,1,-2), Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-4,0,4), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Accent", Font = GOTHB, TextSize = 10})
			c.sectionHeader, c.sectionChevron, c.sectionTiles = h, chevron, {}
		end
		C.__finish = WireSection
		function C.label(it, c)
			c.n += 1
			local h = New("Frame", c.page, {Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, LayoutOrder = c.n})
			tl(h, it, {Size = UDim2.fromScale(1,1), TextColor3 = "@SubText"})
			if c.sectionTiles then table.insert(c.sectionTiles, h) end
		end
		function C.toggle(it, c)
			local r = tile(c, 46, HALF, true)
			local lab = tl(r, it, {Position = UDim2.fromOffset(12,0), Size = UDim2.new(1,-50,1,0)})
			local dot = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-12,0.5,0), Size = UDim2.fromOffset(18,18), BorderSizePixel = 0}), 100)
			ToggleLogic(it, r, function(on)
				Tween(r, {BackgroundColor3 = on and Theme.Accent or Theme.Row}, 0.18)
				Tween(lab, {TextColor3 = on and Theme.Background or Theme.Text}, 0.18)
				Tween(dot, {BackgroundColor3 = on and Theme.Background or Theme.Border}, 0.18)
			end)
		end
		function C.slider(it, c)
			local r = tile(c, 52, FULL)
			tl(r, it, {Position = UDim2.fromOffset(14,7), Size = UDim2.new(1,-100,0,16)})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,7), Size = UDim2.fromOffset(80,16), BackgroundTransparency = 1,
				TextColor3 = "@Accent", Font = GOTHB, TextSize = 12, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(14,34), Size = UDim2.new(1,-28,0,8), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 100)
			SliderLogic(it, r, track, function(a, txt) Tween(fill, {Size = UDim2.fromScale(a,1)}, 0.08); val.Text = txt end)
		end
		local function stacked(it, c, logic)
			local r = tile(c, 52, HALF, true)
			tl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-24,0,16), TextColor3 = "@SubText", TextSize = 10})
			local v = New("TextLabel", r, {Position = UDim2.fromOffset(12,24), Size = UDim2.new(1,-24,0,22), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = GOTHB,
				TextSize = 15, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
			logic(it, r, function(t) v.Text = t end)
		end
		function C.choice(it, c) stacked(it, c, ChoiceLogic) end
		function C.bind(it, c) stacked(it, c, BindLogic) end
		function C.info(it, c)
			local r = tile(c, 52, HALF)
			tl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-24,0,16), TextColor3 = "@SubText", TextSize = 10})
			local v = New("TextLabel", r, {Position = UDim2.fromOffset(12,24), Size = UDim2.new(1,-24,0,22), BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHB,
				TextSize = 13, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.action(it, c)
			local r = tile(c, 40, HALF, true, "@Accent")
			tl(r, it, {Size = UDim2.fromScale(1,1), TextColor3 = "@Background", Font = GOTHB, TextXAlignment = CENTER})
			Connect(r.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = tile(c, it.h + 6, FULL, false, "@Background")
			New("UIStroke", r, {Color = "@Border", Thickness = 1})
			MakeInput(r, it, {Position = UDim2.fromOffset(10,4), Size = UDim2.new(1,-20,1,-8), BackgroundTransparency = 1})
		end
		function C.log(it, c)
			local r = tile(c, 280, FULL, false, "@Background")
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(8,8), Size = UDim2.new(1,-16,1,-16), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = tile(c, 84, FULL)
			local img = MakeAvatar(r, 60); img.Position = UDim2.fromOffset(12,12)
			New("TextLabel", r, {Position = UDim2.fromOffset(84,20), Size = UDim2.new(1,-96,0,22), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = "@Text", Font = GOTHB, TextSize = 15, TextXAlignment = LEFT})
			New("TextLabel", r, {Position = UDim2.fromOffset(84,44), Size = UDim2.new(1,-96,0,16), BackgroundTransparency = 1, Text = "@" .. LocalPlayer.DisplayName, TextColor3 = "@SubText", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
		end

		for i, tab in ipairs(Spec) do
			local page = New("ScrollingFrame", Body, {Name = tab.Key, Position = UDim2.fromOffset(12,10), Size = UDim2.new(1,-24,1,-20), BackgroundTransparency = 1, BorderSizePixel = 0,
				ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false})
			local layout = New("UIListLayout", page, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			pcall(function() layout.Wraps = true end)
			New("UIPadding", page, {PaddingRight = UDim.new(0,8), PaddingBottom = UDim.new(0,10)})
			Pages[tab.Key] = page
			local b = Round(New("TextButton", dockList, {Size = UDim2.fromOffset(80,36), BackgroundColor3 = "@Accent", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i}), 18)
			local lab = New("TextLabel", b, {Size = UDim2.new(1,-8,1,0), Position = UDim2.fromOffset(4,0), BackgroundTransparency = 1, TextColor3 = Theme.SubText, Font = GOTHB, TextSize = 11, TextScaled = true})
			New("UITextSizeConstraint", lab, {MaxTextSize = 11, MinTextSize = 6})
			Locale.Bind(lab, tab.Locale)
			Btns[tab.Key] = {Btn = b, Label = lab}
			Connect(b.MouseButton1Click, function() Select(tab.Key) end)
			BuildTab(tab, page, C)
		end
		Select(Spec[1].Key)
		return {
			Show = function(state)
				if state then Root.Visible = true end
				Tween(Scale, {Scale = state and S.UIScale or S.UIScale * 0.94}, 0.28, Enum.EasingStyle.Back)
				Tween(Dock, {GroupTransparency = state and S.UIOpacity or 1}, 0.2)
				Tween(Panel, {GroupTransparency = state and S.UIOpacity or 1}, 0.2)
				if not state then task.delay(0.22, function() if not MenuState.Open and Root.Parent then Root.Visible = false end end) end
			end,
			Scale = function(v) Scale.Scale = v end,
			Opacity = function(v) if MenuState.Open then Dock.GroupTransparency = v; Panel.GroupTransparency = v end end,
			Destroy = function() glow:Cancel() end,
		}
	end

	Skins.Terminal = function()
		local Root = New("CanvasGroup", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,24), Size = UDim2.fromOffset(820,470),
			BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1, Visible = false})
		local Scale = New("UIScale", Root, {Scale = 0.94})
		New("UIStroke", Root, {Color = "@Accent", Thickness = 1})
		local Top = New("Frame", Root, {Size = UDim2.new(1,0,0,24), BackgroundColor3 = "@Secondary", BorderSizePixel = 0})
		local prompt = New("TextLabel", Top, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(1,-90,1,0), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = CODE, TextSize = 12, TextXAlignment = LEFT})
		local function TopBtn(text, color, x, cb)
			local b = New("TextButton", Top, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,x,0,0), Size = UDim2.fromOffset(34,24), BackgroundTransparency = 1, Text = text,
				TextColor3 = color, Font = CODE, TextSize = 12})
			Connect(b.MouseButton1Click, cb)
		end
		TopBtn("[x]", Color3.fromRGB(255,90,100), 0, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		TopBtn("[_]", Theme.Text, -34, function() SetMenu(false) end)
		Draggable(Top, Root)

		local Strip = New("Frame", Root, {Position = UDim2.fromOffset(0,24), Size = UDim2.new(1,0,0,26), BackgroundColor3 = "@Row", BorderSizePixel = 0})
		New("UIListLayout", Strip, {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder})
		local foot = New("TextLabel", Root, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,10,1,-4), Size = UDim2.new(1,-20,0,14), BackgroundTransparency = 1, TextColor3 = "@Muted",
			Font = CODE, TextSize = 10, TextXAlignment = LEFT})
		local function PaintFoot() foot.Text = Locale.T("MENU_KEY") .. ": " .. KeyName(K.Menu) .. "   |   LMB click  RMB previous" end
		PaintFoot(); Locale.OnChange(PaintFoot); table.insert(OnBind, PaintFoot)
		local Content = New("Frame", Root, {Position = UDim2.fromOffset(0,50), Size = UDim2.new(1,0,1,-68), BackgroundTransparency = 1, ClipsDescendants = true})

		local Pages, Btns, Active = {}, {}, nil
		local function Select(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, b in pairs(Btns) do
				b.Btn.BackgroundTransparency = n == name and 0 or 1
				b.Btn.TextColor3 = n == name and Theme.Background or Theme.SubText
			end
			prompt.Text = "vortex@" .. string.lower(LocalPlayer.Name) .. ":~$ ./hub --tab=" .. string.lower(name)
		end
		table.insert(Refreshers, function() if Active then Select(Active) end end)

		local C = {}
		local function row(c, h, click)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			Connect(r.MouseEnter, function() Tween(r, {BackgroundTransparency = 0.55}, 0.1) end)
			Connect(r.MouseLeave, function() Tween(r, {BackgroundTransparency = 1}, 0.1) end)
			return r
		end
		local function tl(r, it, props)
			local base = {BackgroundTransparency = 1, TextColor3 = "@Text", Font = CODE, TextSize = 12, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd}
			for k, v in pairs(props) do base[k] = v end
			return Lbl(r, it, base)
		end
		local function rightText(r, color)
			return New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-10,0,0), Size = UDim2.new(0.4,-10,1,0), BackgroundTransparency = 1, TextColor3 = color or "@Accent",
				Font = CODE, TextSize = 12, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
		end
		function C.section(it, c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			tl(h, it, {Position = UDim2.fromOffset(10,4), Size = UDim2.new(1,-26,0,16), TextColor3 = "@Accent", TextSize = 12})
			New("Frame", h, {Position = UDim2.new(0,10,1,-1), Size = UDim2.new(1,-20,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-10,0,4), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Accent", Font = CODE, TextSize = 11})
			c.n += 1
			local group = New("Frame", c.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = c.n})
			New("UIListLayout", group, {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder})
			c.group, c.gn = group, 1
			CollapseOnScroll(h, group, chevron)
		end
		function C.label(it, c)
			c.n += 1
			local parent = c.group or c.page
			local h = New("Frame", parent, {Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			tl(h, it, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(1,-20,1,0), TextColor3 = "@SubText", TextSize = 11})
		end
		function C.toggle(it, c)
			local r = row(c, 24, true)
			tl(r, it, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(0.6,-10,1,0)})
			local v = rightText(r)
			local function paint(on)
				v.Text = "[" .. Locale.T(on and "LBL_ON" or "LBL_OFF") .. "]"
				v.TextColor3 = on and Theme.Accent or Theme.Muted
			end
			ToggleLogic(it, r, paint)
			Locale.OnChange(function() if v.Parent then paint(S[it.k]) end end)
		end
		function C.slider(it, c)
			local r = row(c, 24)
			tl(r, it, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(0.4,-10,1,0)})
			local track = New("Frame", r, {Position = UDim2.new(0.42,0,0.5,-2), Size = UDim2.new(0.4,0,0,4), BackgroundColor3 = "@Border", BorderSizePixel = 0})
			local fill = New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-10,0,0), Size = UDim2.new(0.16,-10,1,0), BackgroundTransparency = 1, TextColor3 = "@Accent",
				Font = CODE, TextSize = 12, TextXAlignment = RIGHT})
			SliderLogic(it, r, track, function(a, txt) fill.Size = UDim2.fromScale(a,1); val.Text = txt end)
		end
		local function valueRow(it, c, logic, wrap)
			local r = row(c, 24, true)
			tl(r, it, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(0.6,-10,1,0)})
			local v = rightText(r)
			logic(it, r, function(t) v.Text = wrap(t) end)
		end
		function C.choice(it, c) valueRow(it, c, ChoiceLogic, function(t) return "< " .. t .. " >" end) end
		function C.bind(it, c) valueRow(it, c, BindLogic, function(t) return "[" .. t .. "]" end) end
		function C.action(it, c)
			local r = row(c, 24, true)
			New("TextLabel", r, {Position = UDim2.fromOffset(10,0), Size = UDim2.fromOffset(14,24), BackgroundTransparency = 1, Text = ">", TextColor3 = "@Accent", Font = CODE, TextSize = 12})
			tl(r, it, {Position = UDim2.fromOffset(26,0), Size = UDim2.new(1,-36,1,0), TextColor3 = "@Accent"})
			Connect(r.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = row(c, it.h - 6)
			New("UIStroke", r, {Color = "@Border", Thickness = 1})
			MakeInput(r, it, {Position = UDim2.fromOffset(6,3), Size = UDim2.new(1,-12,1,-6), BackgroundTransparency = 1})
		end
		function C.info(it, c)
			local r = row(c, 24)
			tl(r, it, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(0.4,-10,1,0), TextColor3 = "@SubText"})
			local v = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-10,0,0), Size = UDim2.new(0.6,-10,1,0), BackgroundTransparency = 1, TextColor3 = "@Text",
				Font = CODE, TextSize = 12, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.log(it, c)
			local r = row(c, 300)
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(6,6), Size = UDim2.new(1,-12,1,-12), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = row(c, 76)
			local img = MakeAvatar(r, 60); img.Position = UDim2.fromOffset(10,8)
			New("TextLabel", r, {Position = UDim2.fromOffset(80,16), Size = UDim2.new(1,-90,0,20), BackgroundTransparency = 1, Text = "user   = " .. LocalPlayer.Name, TextColor3 = "@Text", Font = CODE, TextSize = 13, TextXAlignment = LEFT})
			New("TextLabel", r, {Position = UDim2.fromOffset(80,38), Size = UDim2.new(1,-90,0,20), BackgroundTransparency = 1, Text = "alias  = @" .. LocalPlayer.DisplayName, TextColor3 = "@SubText", Font = CODE, TextSize = 12, TextXAlignment = LEFT})
		end

		for i, tab in ipairs(Spec) do
			local page = New("ScrollingFrame", Content, {Name = tab.Key, Position = UDim2.fromOffset(6,6), Size = UDim2.new(1,-12,1,-8), BackgroundTransparency = 1, BorderSizePixel = 0,
				ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false})
			New("UIListLayout", page, {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder})
			New("UIPadding", page, {PaddingRight = UDim.new(0,6), PaddingBottom = UDim.new(0,8)})
			Pages[tab.Key] = page
			local b = New("TextButton", Strip, {Size = UDim2.new(1 / #Spec,0,1,0), BackgroundColor3 = "@Accent", BackgroundTransparency = 1, TextColor3 = "@SubText", Font = CODE, TextSize = 11,
				AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i})
			local function paintTab() b.Text = "[" .. i .. "] " .. Locale.T(tab.Locale) end
			paintTab(); Locale.OnChange(paintTab)
			Btns[tab.Key] = {Btn = b}
			Connect(b.MouseButton1Click, function() Select(tab.Key) end)
			BuildTab(tab, page, C)
		end
		Select(Spec[1].Key)
		return {
			Show = function(state) StandardShow(Root, Scale, state) end,
			Scale = function(v) if MenuState.Open then Tween(Scale, {Scale = v}, 0.1) end end,
			Opacity = function(v) if MenuState.Open then Tween(Root, {GroupTransparency = v}, 0.1) end end,
			Destroy = function() end,
		}
	end

	Skins.Notch = function()
		local Root = New("Frame", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,10), Size = UDim2.fromOffset(560,400), BackgroundTransparency = 1, Visible = false})
		local Scale = New("UIScale", Root, {Scale = 0.92})
		local Pill = Round(New("CanvasGroup", Root, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.fromScale(0.5,0), Size = UDim2.fromOffset(0,40),
			AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = "@Background", BorderSizePixel = 0}), 20)
		local glow = GlowStroke(Pill)
		local PillList = New("Frame", Pill, {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X})
		New("UIListLayout", PillList, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", PillList, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
		Locale.Bind(New("TextLabel", PillList, {Size = UDim2.fromOffset(60,40), BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHB, TextSize = 12, TextXAlignment = LEFT, LayoutOrder = 0}), "APP_NAME")
		local closeBtn = Round(New("TextButton", PillList, {Size = UDim2.fromOffset(24,24), BackgroundColor3 = "@Row", Text = "X", TextColor3 = Color3.fromRGB(255,90,100),
			Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = 1000}), 12)
		Connect(closeBtn.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		Draggable(Pill, Root)

		local Sheet = Round(New("CanvasGroup", Root, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,46), Size = UDim2.fromOffset(520,0),
			BackgroundColor3 = "@Secondary", BorderSizePixel = 0, ClipsDescendants = true, Visible = false, GroupTransparency = 1}), 16)
		New("UIStroke", Sheet, {Color = "@Border", Thickness = 1})
		local SheetHead = New("Frame", Sheet, {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1})
		local sheetTitle = New("TextLabel", SheetHead, {Position = UDim2.fromOffset(12,0), Size = UDim2.new(1,-40,1,0), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = GOTHB, TextSize = 12, TextXAlignment = LEFT})
		local Page = New("ScrollingFrame", Sheet, {Position = UDim2.fromOffset(10,32), Size = UDim2.new(1,-20,1,-40), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
		New("UIListLayout", Page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", Page, {PaddingBottom = UDim.new(0,10), PaddingRight = UDim.new(0,4)})

		local Pages, Btns, Active, Open = {}, {}, nil, false
		local function CloseSheet()
			Open = false
			Tween(Sheet, {Size = UDim2.fromOffset(520,0), GroupTransparency = 1}, 0.18)
			task.delay(0.19, function() if not Open then Sheet.Visible = false end end)
		end
		local function OpenSheet(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, b in pairs(Btns) do Tween(b.Bg, {BackgroundColor3 = n == name and Theme.Accent or Theme.Row}, 0.15) end
			for _, t in ipairs(Spec) do if t.Key == name then sheetTitle.Text = Locale.T(t.Locale) end end
			Sheet.Visible = true; Open = true
			Tween(Sheet, {Size = UDim2.fromOffset(520,300), GroupTransparency = 0}, 0.2)
		end
		local function Toggle(name)
			if Open and Active == name then CloseSheet() else OpenSheet(name) end
		end
		table.insert(Refreshers, function() if Open and Active then for _, t in ipairs(Spec) do if t.Key == Active then sheetTitle.Text = Locale.T(t.Locale) end end end end)

		local C = {}
		local function row(c, h, click)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			return Round(r, 8)
		end
		local function rl(r, it, w) return Lbl(r, it, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,w or -170,1,0), TextColor3 = "@Text", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT}) end
		function C.section(it, c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			Lbl(h, it, {Position = UDim2.fromOffset(2,0), Size = UDim2.new(1,-20,1,0), TextColor3 = "@Accent", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-2,0.5,0), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Muted", Font = GOTHB, TextSize = 9})
			c.n += 1
			local group = New("Frame", c.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = c.n})
			New("UIListLayout", group, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder})
			c.group, c.gn = group, 1
			CollapseOnScroll(h, group, chevron)
		end
		function C.label(it, c)
			c.n += 1
			local parent = c.group or c.page
			local h = New("Frame", parent, {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			Lbl(h, it, {Size = UDim2.new(1,0,1,0), TextColor3 = "@SubText", Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		end
		function C.toggle(it, c)
			local r = row(c, 34, true); rl(r, it, -60)
			local track = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(32,17), BorderSizePixel = 0}), 100)
			local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(12,12), BorderSizePixel = 0}), 100)
			ToggleLogic(it, r, function(on)
				Tween(track, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.15)
				Tween(knob, {Position = on and UDim2.new(1,-14,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.Background or Theme.Muted}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 46)
			Lbl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-90,0,14), TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.fromOffset(70,14), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 10, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 100)
			SliderLogic(it, r, track, function(a, txt) Tween(fill, {Size = UDim2.fromScale(a,1)}, 0.08); val.Text = txt end)
		end
		local function sideBtn(r)
			local b = Round(New("TextButton", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(110,22), BackgroundColor3 = "@Background",
				Text = "", TextColor3 = "@Text", Font = GOTHB, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			return b
		end
		function C.choice(it, c)
			local r = row(c, 34); rl(r, it); local b = sideBtn(r)
			local sw = AttachColorSwatch(it, r, 14)
			if sw then sw.Position = UDim2.new(1,-128,0.5,0) end
			ChoiceLogic(it, b, function(t) b.Text = t end)
		end
		function C.bind(it, c)
			local r = row(c, 34); rl(r, it); local b = sideBtn(r)
			BindLogic(it, b, function(t) b.Text = t end)
		end
		function C.action(it, c)
			local r = row(c, 32)
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,1,-8), BackgroundColor3 = "@Accent", TextColor3 = "@Background",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Connect(b.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = row(c, it.h)
			local box = Round(MakeInput(r, it, {Position = UDim2.fromOffset(10,6), Size = UDim2.new(1,-20,1,-12), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 6)
			New("UIPadding", box, {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8)})
		end
		function C.info(it, c)
			local r = row(c, 32); rl(r, it, -220)
			local v = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(200,18), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = GOTHB, TextSize = 11, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.log(it, c)
			local r = row(c, 240)
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(8,8), Size = UDim2.new(1,-16,1,-16), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = row(c, 64)
			local img = MakeAvatar(r, 46); img.Position = UDim2.fromOffset(9,9)
			New("TextLabel", r, {Position = UDim2.fromOffset(62,14), Size = UDim2.new(1,-70,0,18), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = "@Text", Font = GOTHB, TextSize = 13, TextXAlignment = LEFT})
			New("TextLabel", r, {Position = UDim2.fromOffset(62,32), Size = UDim2.new(1,-70,0,14), BackgroundTransparency = 1, Text = "@" .. LocalPlayer.DisplayName, TextColor3 = "@SubText", Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		end

		for i, tab in ipairs(Spec) do
			local page = New("ScrollingFrame", Page, {Name = tab.Key, Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0,
				Visible = false, CanvasSize = UDim2.new(), AutomaticSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0})
			New("UIListLayout", page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			Pages[tab.Key] = page
			local b = Round(New("TextButton", PillList, {Size = UDim2.fromOffset(30,30), BackgroundColor3 = "@Row", Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i}), 10)
			local lab = New("TextLabel", b, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 9, TextXAlignment = CENTER, TextTruncate = Enum.TextTruncate.AtEnd})
			lab.Text = tostring(i)
			Btns[tab.Key] = {Bg = b}
			Connect(b.MouseButton1Click, function() Toggle(tab.Key) end)
			BuildTab(tab, page, C)
		end

		return {
			Show = function(state)
				if state then Root.Visible = true end
				Tween(Scale, {Scale = state and S.UIScale or S.UIScale * 0.9}, 0.25, Enum.EasingStyle.Back)
				Tween(Pill, {GroupTransparency = state and S.UIOpacity or 1}, 0.2)
				if not state then CloseSheet(); task.delay(0.22, function() if not MenuState.Open and Root.Parent then Root.Visible = false end end) end
			end,
			Scale = function(v) Scale.Scale = v end,
			Opacity = function(v) if MenuState.Open then Pill.GroupTransparency = v end end,
			Destroy = function() glow:Cancel() end,
		}
	end

	Skins.HUDStrip = function()
		local Root = New("Frame", MenuGui, {Name = "Main", Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Visible = false})
		local Strip = Round(New("CanvasGroup", Root, {AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-14), Size = UDim2.fromOffset(680,36),
			BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1}), 10)
		local glow = GlowStroke(Strip)
		local StripScale = New("UIScale", Strip, {Scale = 0.95})
		local List = New("Frame", Strip, {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1})
		New("UIListLayout", List, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,2), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", List, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
		Draggable(Strip, Strip)

		local function LiveField(w)
			return New("TextLabel", List, {Size = UDim2.fromOffset(w,36), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = CODE, TextSize = 11, TextXAlignment = LEFT})
		end
		local fpsF, pingF, aimF, trigF = LiveField(56), LiveField(70), LiveField(60), LiveField(64)
		New("Frame", List, {Size = UDim2.fromOffset(1,18), BackgroundColor3 = "@Border", BorderSizePixel = 0})
		local closeBtn = Round(New("TextButton", List, {Size = UDim2.fromOffset(24,24), BackgroundColor3 = "@Row", Text = "X", TextColor3 = Color3.fromRGB(255,90,100),
			Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = 1000}), 12)
		Connect(closeBtn.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)

		local hudAccum, hudFrames = 0, 0
		Connect(RunService.RenderStepped, function(dt)
			if Unloaded or not Strip.Parent then return end
			hudAccum += dt; hudFrames += 1
			if hudAccum >= 0.25 then
				fpsF.Text = "FPS " .. math.floor(hudFrames / hudAccum + 0.5)
				hudAccum, hudFrames = 0, 0
			end
			local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			pingF.Text = "PING " .. (ok and math.floor(v) or 0)
			aimF.Text = "AIM " .. (S.AimbotEnabled and (Aim.Player and "LOCK" or "ON") or "OFF")
			aimF.TextColor3 = S.AimbotEnabled and (Aim.Player and Color3.fromRGB(255,90,100) or Theme.Accent) or Theme.Muted
			trigF.Text = "TRG " .. (S.TriggerEnabled and (Trigger.Player and "LOCK" or "ON") or "OFF")
			trigF.TextColor3 = S.TriggerEnabled and (Trigger.Player and Color3.fromRGB(255,90,100) or Theme.Accent) or Theme.Muted
		end)

		local Panel = Round(New("CanvasGroup", Root, {AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-58), Size = UDim2.fromOffset(520,0),
			BackgroundColor3 = "@Secondary", BorderSizePixel = 0, ClipsDescendants = true, Visible = false, GroupTransparency = 1}), 14)
		New("UIStroke", Panel, {Color = "@Border", Thickness = 1})
		local PanelHead = New("Frame", Panel, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,0,1,0), Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1})
		local panelTitle = New("TextLabel", PanelHead, {Position = UDim2.fromOffset(12,0), Size = UDim2.new(1,-30,1,0), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
		local Page = New("ScrollingFrame", Panel, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,10,1,-30), Size = UDim2.new(1,-20,1,-40), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
		New("UIListLayout", Page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", Page, {PaddingBottom = UDim.new(0,8), PaddingRight = UDim.new(0,4)})

		local Pages, Segs, Active, PanelOpen = {}, {}, nil, false
		local function ClosePanel()
			PanelOpen = false
			Tween(Panel, {Size = UDim2.fromOffset(520,0), GroupTransparency = 1}, 0.18)
			task.delay(0.19, function() if not PanelOpen then Panel.Visible = false end end)
			for _, b in pairs(Segs) do Tween(b, {BackgroundColor3 = Theme.Row}, 0.15) end
		end
		local function OpenPanel(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, b in pairs(Segs) do Tween(b, {BackgroundColor3 = n == name and Theme.Accent or Theme.Row}, 0.15) end
			for _, t in ipairs(Spec) do if t.Key == name then panelTitle.Text = Locale.T(t.Locale) end end
			Panel.Visible = true; PanelOpen = true
			Tween(Panel, {Size = UDim2.fromOffset(520, 360), GroupTransparency = 0}, 0.2)
		end
		local function Toggle(name)
			if PanelOpen and Active == name then ClosePanel() else OpenPanel(name) end
		end
		table.insert(Refreshers, function() if PanelOpen and Active then for _, t in ipairs(Spec) do if t.Key == Active then panelTitle.Text = Locale.T(t.Locale) end end end end)

		local C = {}
		local function row(c, h, click)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			return Round(r, 8)
		end
		local function rl(r, it, w) return Lbl(r, it, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,w or -170,1,0), TextColor3 = "@Text", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT}) end
		function C.section(it, c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			Lbl(h, it, {Position = UDim2.fromOffset(2,0), Size = UDim2.new(1,-20,1,0), TextColor3 = "@Accent", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-2,0.5,0), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Muted", Font = GOTHB, TextSize = 9})
			c.n += 1
			local group = New("Frame", c.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = c.n})
			New("UIListLayout", group, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder})
			c.group, c.gn = group, 1
			CollapseOnScroll(h, group, chevron)
		end
		function C.label(it, c)
			c.n += 1
			local parent = c.group or c.page
			local h = New("Frame", parent, {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			Lbl(h, it, {Size = UDim2.new(1,0,1,0), TextColor3 = "@SubText", Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		end
		function C.toggle(it, c)
			local r = row(c, 34, true); rl(r, it, -60)
			local track = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(32,17), BorderSizePixel = 0}), 100)
			local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(12,12), BorderSizePixel = 0}), 100)
			ToggleLogic(it, r, function(on)
				Tween(track, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.15)
				Tween(knob, {Position = on and UDim2.new(1,-14,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.Background or Theme.Muted}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 46)
			Lbl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-90,0,14), TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.fromOffset(70,14), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 10, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 100)
			SliderLogic(it, r, track, function(a, txt) Tween(fill, {Size = UDim2.fromScale(a,1)}, 0.08); val.Text = txt end)
		end
		local function sideBtn(r)
			local b = Round(New("TextButton", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(110,22), BackgroundColor3 = "@Background",
				Text = "", TextColor3 = "@Text", Font = GOTHB, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			return b
		end
		function C.choice(it, c)
			local r = row(c, 34); rl(r, it); local b = sideBtn(r)
			local sw = AttachColorSwatch(it, r, 14)
			if sw then sw.Position = UDim2.new(1,-128,0.5,0) end
			ChoiceLogic(it, b, function(t) b.Text = t end)
		end
		function C.bind(it, c)
			local r = row(c, 34); rl(r, it); local b = sideBtn(r)
			BindLogic(it, b, function(t) b.Text = t end)
		end
		function C.action(it, c)
			local r = row(c, 32)
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,1,-8), BackgroundColor3 = "@Accent", TextColor3 = "@Background",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Connect(b.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = row(c, it.h)
			local box = Round(MakeInput(r, it, {Position = UDim2.fromOffset(10,6), Size = UDim2.new(1,-20,1,-12), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 6)
			New("UIPadding", box, {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8)})
		end
		function C.info(it, c)
			local r = row(c, 32); rl(r, it, -220)
			local v = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(200,18), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = GOTHB, TextSize = 11, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.log(it, c)
			local r = row(c, 240)
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(8,8), Size = UDim2.new(1,-16,1,-16), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = row(c, 64)
			local img = MakeAvatar(r, 46); img.Position = UDim2.fromOffset(9,9)
			New("TextLabel", r, {Position = UDim2.fromOffset(62,14), Size = UDim2.new(1,-70,0,18), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = "@Text", Font = GOTHB, TextSize = 13, TextXAlignment = LEFT})
			New("TextLabel", r, {Position = UDim2.fromOffset(62,32), Size = UDim2.new(1,-70,0,14), BackgroundTransparency = 1, Text = "@" .. LocalPlayer.DisplayName, TextColor3 = "@SubText", Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		end

		for i, tab in ipairs(Spec) do
			local page = New("Frame", Page, {Name = tab.Key, Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false})
			New("UIListLayout", page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			Pages[tab.Key] = page
			local b = Round(New("TextButton", List, {Size = UDim2.fromOffset(30,28), BackgroundColor3 = "@Row", Text = tostring(i), TextColor3 = "@SubText",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i + 10}), 8)
			Segs[tab.Key] = b
			Connect(b.MouseButton1Click, function() Toggle(tab.Key) end)
			BuildTab(tab, page, C)
		end

		return {
			Show = function(state)
				if state then Root.Visible = true end
				Tween(StripScale, {Scale = state and 1 or 0.95}, 0.22, Enum.EasingStyle.Back)
				Tween(Strip, {GroupTransparency = state and S.UIOpacity or 1}, 0.2)
				if not state then ClosePanel(); task.delay(0.22, function() if not MenuState.Open and Root.Parent then Root.Visible = false end end) end
			end,
			Scale = function(v) StripScale.Scale = v end,
			Opacity = function(v) if MenuState.Open then Strip.GroupTransparency = v end end,
			Destroy = function() glow:Cancel() end,
		}
	end

	Skins.Radial = function()
		local Root = New("Frame", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.28,0.5), Size = UDim2.fromOffset(720,420), BackgroundTransparency = 1, Visible = false})
		local RingHolder = New("Frame", Root, {AnchorPoint = Vector2.new(0,0.5), Position = UDim2.fromOffset(0,210), Size = UDim2.fromOffset(220,220), BackgroundTransparency = 1})
		local RingScale = New("UIScale", RingHolder, {Scale = 0.9})
		local Ring = Round(New("CanvasGroup", RingHolder, {Size = UDim2.fromOffset(220,220), BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1}), 100)
		local glow = GlowStroke(Ring)
		local Center = Round(New("Frame", Ring, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(68,68), BackgroundColor3 = "@Secondary", BorderSizePixel = 0, ZIndex = 3}), 100)
		New("UIStroke", Center, {Color = "@Border", Thickness = 1})
		Locale.Bind(New("TextLabel", Center, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHB, TextSize = 12, ZIndex = 3}), "APP_NAME")
		local closeBtn = Round(New("TextButton", Ring, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(20,20),
			BackgroundColor3 = "@Row", Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 4, Visible = false}), 100)
		New("TextLabel", closeBtn, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "X", TextColor3 = Color3.fromRGB(255,90,100), Font = GOTHB, TextSize = 11})
		Draggable(Center, RingHolder)

		local Panel = Round(New("CanvasGroup", Root, {AnchorPoint = Vector2.new(0,0.5), Position = UDim2.fromOffset(236,210), Size = UDim2.fromOffset(0,380),
			BackgroundColor3 = "@Secondary", BorderSizePixel = 0, ClipsDescendants = true, Visible = false, GroupTransparency = 1}), 14)
		New("UIStroke", Panel, {Color = "@Border", Thickness = 1})
		local PanelHead = New("Frame", Panel, {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1})
		local panelTitle = New("TextLabel", PanelHead, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,-20,1,0), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = GOTHB, TextSize = 12, TextXAlignment = LEFT})
		local Page = New("ScrollingFrame", Panel, {Position = UDim2.fromOffset(10,34), Size = UDim2.new(1,-20,1,-44), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
		New("UIListLayout", Page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", Page, {PaddingBottom = UDim.new(0,10), PaddingRight = UDim.new(0,4)})

		local Pages, Wedges, Active, PanelOpen = {}, {}, nil, false
		local function ClosePanel()
			PanelOpen = false
			Tween(Panel, {Size = UDim2.fromOffset(0,380), GroupTransparency = 1}, 0.2)
			task.delay(0.21, function() if not PanelOpen then Panel.Visible = false end end)
			for _, w in pairs(Wedges) do Tween(w.Icon, {BackgroundColor3 = Theme.Row}, 0.15) end
			closeBtn.Visible = false
		end
		local function OpenPanel(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, w in pairs(Wedges) do Tween(w.Icon, {BackgroundColor3 = n == name and Theme.Accent or Theme.Row}, 0.15) end
			for _, t in ipairs(Spec) do if t.Key == name then panelTitle.Text = Locale.T(t.Locale) end end
			Panel.Visible = true; PanelOpen = true
			Tween(Panel, {Size = UDim2.fromOffset(360,380), GroupTransparency = 0}, 0.22, Enum.EasingStyle.Back)
			closeBtn.Visible = true
		end
		local function Toggle(name)
			if PanelOpen and Active == name then ClosePanel() else OpenPanel(name) end
		end
		Connect(closeBtn.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		table.insert(Refreshers, function() if PanelOpen and Active then for _, t in ipairs(Spec) do if t.Key == Active then panelTitle.Text = Locale.T(t.Locale) end end end end)

		local C = {}
		local function row(c, h, click)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			return Round(r, 8)
		end
		local function rl(r, it, w) return Lbl(r, it, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,w or -170,1,0), TextColor3 = "@Text", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT}) end
		function C.section(it, c)
			c.n += 1
			local h = New("TextButton", c.page, {Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = c.n})
			Lbl(h, it, {Position = UDim2.fromOffset(2,0), Size = UDim2.new(1,-20,1,0), TextColor3 = "@Accent", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
			local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-2,0.5,0), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1,
				Text = "v", TextColor3 = "@Muted", Font = GOTHB, TextSize = 9})
			c.n += 1
			local group = New("Frame", c.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = c.n})
			New("UIListLayout", group, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder})
			c.group, c.gn = group, 1
			CollapseOnScroll(h, group, chevron)
		end
		function C.label(it, c)
			c.n += 1
			local parent = c.group or c.page
			local h = New("Frame", parent, {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			Lbl(h, it, {Size = UDim2.new(1,0,1,0), TextColor3 = "@SubText", Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		end
		function C.toggle(it, c)
			local r = row(c, 34, true); rl(r, it, -60)
			local track = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(32,17), BorderSizePixel = 0}), 100)
			local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(12,12), BorderSizePixel = 0}), 100)
			ToggleLogic(it, r, function(on)
				Tween(track, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.15)
				Tween(knob, {Position = on and UDim2.new(1,-14,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.Background or Theme.Muted}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 46)
			Lbl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-90,0,14), TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.fromOffset(70,14), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 10, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 100)
			SliderLogic(it, r, track, function(a, txt) Tween(fill, {Size = UDim2.fromScale(a,1)}, 0.08); val.Text = txt end)
		end
		local function sideBtn(r)
			local b = Round(New("TextButton", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(110,22), BackgroundColor3 = "@Background",
				Text = "", TextColor3 = "@Text", Font = GOTHB, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			return b
		end
		function C.choice(it, c)
			local r = row(c, 34); rl(r, it); local b = sideBtn(r)
			local sw = AttachColorSwatch(it, r, 14)
			if sw then sw.Position = UDim2.new(1,-128,0.5,0) end
			ChoiceLogic(it, b, function(t) b.Text = t end)
		end
		function C.bind(it, c)
			local r = row(c, 34); rl(r, it); local b = sideBtn(r)
			BindLogic(it, b, function(t) b.Text = t end)
		end
		function C.action(it, c)
			local r = row(c, 32)
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,1,-8), BackgroundColor3 = "@Accent", TextColor3 = "@Background",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Connect(b.MouseButton1Click, it.fn)
		end
		function C.input(it, c)
			local r = row(c, it.h)
			local box = Round(MakeInput(r, it, {Position = UDim2.fromOffset(10,6), Size = UDim2.new(1,-20,1,-12), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 6)
			New("UIPadding", box, {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8)})
		end
		function C.info(it, c)
			local r = row(c, 32); rl(r, it, -220)
			local v = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(200,18), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = GOTHB, TextSize = 11, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})
			InfoReg(v, it)
		end
		function C.log(it, c)
			local r = row(c, 240)
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(8,8), Size = UDim2.new(1,-16,1,-16), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,1), SortOrder = Enum.SortOrder.LayoutOrder})
			Widgets.log = s
		end
		function C.avatar(it, c)
			local r = row(c, 64)
			local img = MakeAvatar(r, 46); img.Position = UDim2.fromOffset(9,9)
			New("TextLabel", r, {Position = UDim2.fromOffset(62,14), Size = UDim2.new(1,-70,0,18), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = "@Text", Font = GOTHB, TextSize = 13, TextXAlignment = LEFT})
			New("TextLabel", r, {Position = UDim2.fromOffset(62,32), Size = UDim2.new(1,-70,0,14), BackgroundTransparency = 1, Text = "@" .. LocalPlayer.DisplayName, TextColor3 = "@SubText", Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		end

		local count = #Spec
		for i, tab in ipairs(Spec) do
			local page = New("Frame", Page, {Name = tab.Key, Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false})
			New("UIListLayout", page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			Pages[tab.Key] = page
			local angle = -90 + (i - 1) * (360 / count)
			local rad = math.rad(angle)
			local r0 = 88
			local icon = Round(New("TextButton", Ring, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5, math.cos(rad) * r0, 0.5, math.sin(rad) * r0),
				Size = UDim2.fromOffset(36,36), BackgroundColor3 = "@Row", Text = tostring(i), TextColor3 = "@SubText", Font = GOTHB, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 2}), 100)
			New("UIStroke", icon, {Color = "@Border", Thickness = 1})
			Wedges[tab.Key] = {Icon = icon}
			Connect(icon.MouseButton1Click, function() Toggle(tab.Key) end)
			BuildTab(tab, page, C)
		end

		return {
			Show = function(state)
				if state then Root.Visible = true end
				Tween(RingScale, {Scale = state and 1 or 0.88}, 0.25, Enum.EasingStyle.Back)
				Tween(Ring, {GroupTransparency = state and S.UIOpacity or 1}, 0.2)
				if not state then ClosePanel(); task.delay(0.22, function() if not MenuState.Open and Root.Parent then Root.Visible = false end end) end
			end,
			Scale = function(v) RingScale.Scale = v end,
			Opacity = function(v) if MenuState.Open then Ring.GroupTransparency = v end end,
			Destroy = function() glow:Cancel() end,
		}
	end

	Unload = function()
		if Unloaded then return end
		Unloaded = true
		if Env.VortexUnload == Unload then Env.VortexUnload = nil end
		pcall(function() RunService:UnbindFromRenderStep("VortexAim") end)
		for _, c in ipairs(Conns) do c:Disconnect() end
		table.clear(Conns)
		Freecam.Stop()
		Fly.Stop()
		for part in pairs(Noclip.Parts) do if part.Parent then part.CanCollide = true end end
		table.clear(Noclip.Parts); table.clear(Noclip.BaseParts)
		local hum = GetHumanoid()
		if hum then
			if Applied.Speed then hum.WalkSpeed = Applied.WalkSpeed end
			if Applied.Jump then hum.UseJumpPower = Applied.UseJumpPower; hum.JumpPower = Applied.JumpPower end
		end
		World.Restore()
		for i = #EntryOrder, 1, -1 do
			local entity = EntryOrder[i]
			if Entries[entity] then RemoveEntry(entity) end
		end
		table.clear(EntryOrder); table.clear(EntryIndex)
		if Skin then pcall(Skin.Destroy) end
		table.clear(Refreshers); table.clear(Bound)
		table.clear(Locale.Registry); table.clear(Locale.Listeners)
		Overlay:Destroy()
		MenuGui:Destroy()
	end
	Env.VortexUnload = Unload

	local okSkin, resSkin = pcall(Skins[skinName] or Skins.Classic)
	if okSkin then
		Skin = resSkin
	else
		DebugLog.Push("skin", skinName .. " build error: " .. tostring(resSkin), true)
		for _, c in ipairs(MenuGui:GetChildren()) do c:Destroy() end
		table.clear(Widgets); table.clear(Infos); table.clear(OnBind)
		Skin = Skins.Classic()
	end

	Hooks.UIScale = function(v) if Skin then Skin.Scale(v) end end
	Hooks.UIOpacity = function(v) if Skin then Skin.Opacity(v) end end

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		local fab = Round(New("TextButton", MenuGui, {Position = UDim2.fromOffset(12,120), Size = UDim2.fromOffset(42,42), BackgroundColor3 = "@Accent", Text = "V",
			TextColor3 = "@Background", Font = GOTHB, TextSize = 18, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 50}), 100)
		Connect(fab.MouseButton1Click, function() SetMenu(not MenuState.Open) end)
	end

	Connect(UserInputService.InputChanged, function(input)
		local t = input.UserInputType
		if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end
		if Drag.Move then Drag.Move(input.Position) end
		if Drag.Fn then Drag.Fn(input.Position.X) end
	end)
	Connect(UserInputService.InputEnded, function(input)
		if IsPointer(input) then Drag.Move, Drag.Fn = nil, nil end
	end)
	Connect(UserInputService.InputBegan, function(input, processed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not processed then Combat.LastFire = os.clock() end
		if Listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local code = input.KeyCode
				if code == Enum.KeyCode.Escape then code = Enum.KeyCode.Unknown end
				if not (Listening.Key == "Menu" and code == Enum.KeyCode.Unknown) then K[Listening.Key] = code end
				Listening.Show(KeyName(K[Listening.Key]))
				Listening = nil
				for _, fn in ipairs(OnBind) do fn() end
			end
			return
		end
		if processed or input.UserInputType ~= Enum.UserInputType.Keyboard or input.KeyCode == Enum.KeyCode.Unknown then return end
		if input.KeyCode == K.Menu then SetMenu(not MenuState.Open); return end
		for _, key in ipairs(BindOrder) do
			if K[key] == input.KeyCode then
				SetValue(key, not S[key])
				Notify(Locale.T(BindNameKeys[key]) .. ": " .. Locale.T(S[key] and "LBL_ON" or "LBL_OFF"))
			end
		end
	end)
	Connect(UserInputService.JumpRequest, function()
		if S.InfJumpEnabled then
			local hum = GetHumanoid()
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end)

	Connect(RunService.Stepped, function()
		local ch = LocalPlayer.Character
		if S.NoclipEnabled and ch then
			local now = os.clock()
			if Noclip.Character ~= ch or now >= Noclip.Next then
				Noclip.Character, Noclip.Next = ch, now + 0.5
				table.clear(Noclip.BaseParts)
				for _, part in ipairs(ch:GetDescendants()) do
					if part:IsA("BasePart") then table.insert(Noclip.BaseParts, part) end
				end
			end
			for _, part in ipairs(Noclip.BaseParts) do
				if part.Parent and part.CanCollide then Noclip.Parts[part] = true; part.CanCollide = false end
			end
		elseif not S.NoclipEnabled and next(Noclip.Parts) then
			for part in pairs(Noclip.Parts) do if part.Parent then part.CanCollide = true end end
			table.clear(Noclip.Parts); table.clear(Noclip.BaseParts)
			Noclip.Character = nil
		end
	end)

	local function RegisterBotModel(model)
		model = CanonicalBotModel(model)
		if Unloaded or not model then return end

		local hum, root = GetBotParts(model)
		if hum and BotByHumanoid[hum] then return end
		if root and BotByRoot[root] then return end
		if Entries[model] then return end

		local e = NewBotEntry(model)
		if hum then BotByHumanoid[hum] = model end
		if root then BotByRoot[root] = model end
		return e
	end

	local function TryRegisterBotFrom(inst)
		local cur = inst
		for _ = 1, 8 do
			if not cur or cur == Workspace then break end
			if cur:IsA("Model") then RegisterBotModel(cur) end
			cur = cur.Parent
		end
	end


	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then NewPlayerEntry(player) end
	end
	Connect(Players.PlayerAdded, function(player) if player ~= LocalPlayer then NewPlayerEntry(player) end end)
	Connect(Players.PlayerRemoving, function(player) RemoveEntry(player) end)
	Connect(Workspace.DescendantAdded, function(inst)
		if inst:IsA("Model") or inst:IsA("Humanoid") then TryRegisterBotFrom(inst) end
	end)
	Connect(Workspace.DescendantRemoving, function(inst)
		if inst:IsA("Model") then
			local e = Entries[inst]
			if e and e.IsBot then RemoveEntry(inst) end
		end
	end)

	task.spawn(function()
		local descendants = Workspace:GetDescendants()
		for i, obj in ipairs(descendants) do
			if Unloaded then break end
			if obj:IsA("Model") and not IsUnderPlayerCharacter(obj) and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
				RegisterBotModel(obj)
			end
			if i % 350 == 0 then task.wait() end
		end
	end)

	local InfoAccum = 0
	local function UpdateInfos(dt)
		InfoAccum += dt
		if InfoAccum < 0.5 then return end
		InfoAccum = 0
		for _, i in ipairs(Infos) do
			if i.Label.Parent then
				local ok, v = pcall(i.fn)
				if ok then i.Label.Text = v else DebugLog.Push("profile", tostring(v), true) end
			end
		end
	end

	RunService:BindToRenderStep("VortexAim", Enum.RenderPriority.Camera.Value + 1, function(dt)
		if Unloaded then return end
		Camera = Workspace.CurrentCamera or Camera
		Safe("aimbot", Aim.Update, dt)
		Safe("triggerbot", Trigger.Update)
	end)
	Connect(RunService.RenderStepped, function(dt)
		if Unloaded then return end
		Camera = Workspace.CurrentCamera or Camera
		Safe("freecam", Freecam.Update, dt)
		Safe("world", World.Update, dt)
		Safe("fly", Fly.Update)
		Safe("movement", UpdateMovement)
		Safe("overlay", UpdateOverlay, dt)
		Safe("profile", UpdateInfos, dt)
	end)

	SetMenu(true)
	Notify(Locale.T("TOAST_LOADED"))
	DebugLog.Push("system", "hub loaded successfully")
	RenderLog()
end

local function RunMenuPicker(onPick)
	local gui = New("ScreenGui", PlayerGui, {Name = "VortexMenuPick", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 90})
	local dim = New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true})
	Tween(dim, {BackgroundTransparency = 0.4}, 0.4)
	local holder = New("CanvasGroup", gui, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, GroupTransparency = 1})
	Tween(holder, {GroupTransparency = 0}, 0.4)

	New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0.1,0), Size = UDim2.fromOffset(600,30), BackgroundTransparency = 1,
		Text = "CHOOSE YOUR MENU", TextColor3 = Color3.fromRGB(235,235,240), Font = GOTHB, TextSize = 22})
	New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0.1,32), Size = UDim2.fromOffset(600,18), BackgroundTransparency = 1,
		Text = "same features, four completely different interfaces", TextColor3 = Color3.fromRGB(150,150,164), Font = GOTHM, TextSize = 12})

	local closeAll = Round(New("TextButton", holder, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-24,0,24), Size = UDim2.fromOffset(34,34), BackgroundColor3 = Color3.fromRGB(24,24,30),
		Text = "X", TextColor3 = Color3.fromRGB(255,90,100), Font = GOTHB, TextSize = 16, AutoButtonColor = false, BorderSizePixel = 0}), 8)

	local names = {"Classic", "Windows", "Dock", "Terminal", "Notch", "HUDStrip", "Radial"}
	local descs = {Classic = "Sidebar tabs + rows", Windows = "Floating draggable panels", Dock = "Bottom dock + tile grid", Terminal = "Monospace console",
		Notch = "Top pill, tap-to-expand sheet", HUDStrip = "Always-on bottom HUD + pop panel", Radial = "Ring of wedges + side panel"}
	local cardsHolder = New("Frame", holder, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.54), Size = UDim2.fromOffset(#names * 200 + (#names - 1) * 20, 320), BackgroundTransparency = 1})
	New("UIListLayout", cardsHolder, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,20), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center})
	local vpx = Camera.ViewportSize.X
	New("UIScale", cardsHolder, {Scale = math.clamp((vpx - 40) / (#names * 220), 0.4, 1)})

	local function Box(parent, x, y, w, h, color, radius)
		local f = New("Frame", parent, {Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h), BackgroundColor3 = color, BorderSizePixel = 0})
		if radius then New("UICorner", f, {CornerRadius = UDim.new(0, radius)}) end
		return f
	end

	local function Preview(name, parent, p)
		if name == "Classic" then
			Box(parent, 0, 0, 44, 150, p.Secondary)
			for i = 1, 5 do Box(parent, 8, 12 + (i - 1) * 24, 28, 14, i == 1 and p.Row or p.Secondary, 4) end
			Box(parent, 0, 12, 3, 14, p.Accent)
			for i = 1, 4 do
				local r = Box(parent, 54, 10 + (i - 1) * 34, 126, 26, p.Row, 6)
				Box(r, 8, 9, 60, 8, p.SubText, 3)
				Box(r, 96, 7, 22, 12, i % 2 == 1 and p.Accent or p.Border, 6)
			end
		elseif name == "Windows" then
			for i, pos in ipairs({{8, 8}, {70, 30}, {28, 82}}) do
				local w = Box(parent, pos[1], pos[2], 100, 60, p.Background, 5)
				New("UIStroke", w, {Color = p.Border, Thickness = 1})
				Box(w, 0, 0, 100, 12, p.Secondary, 5); Box(w, 0, 11, 100, 2, p.Accent)
				Box(w, 8, 20, 60, 6, p.SubText, 2); Box(w, 8, 32, 44, 6, p.Row, 2); Box(w, 8, 44, 70, 6, p.Row, 2)
			end
		elseif name == "Dock" then
			local pn = Box(parent, 14, 6, 152, 92, p.Background, 10)
			New("UIStroke", pn, {Color = p.Border, Thickness = 1})
			for i = 0, 3 do
				local t = Box(pn, 8 + (i % 2) * 70, 10 + math.floor(i / 2) * 32, 64, 26, i == 0 and p.Accent or p.Row, 7)
				Box(t, 8, 9, 30, 8, i == 0 and p.Background or p.SubText, 3)
			end
			local dk = Box(parent, 30, 112, 120, 26, p.Secondary, 13)
			for i = 0, 3 do Box(dk, 10 + i * 27, 7, 22, 12, i == 0 and p.Accent or p.Row, 6) end
		elseif name == "Terminal" then
			local t = Box(parent, 6, 6, 168, 138, p.Background)
			New("UIStroke", t, {Color = p.Accent, Thickness = 1})
			Box(t, 0, 0, 168, 12, p.Secondary)
			Box(t, 6, 5, 50, 3, p.Accent)
			for i = 1, 7 do
				Box(t, 8, 20 + (i - 1) * 16, 40 + (i * 13) % 50, 5, p.SubText)
				Box(t, 130, 20 + (i - 1) * 16, 26, 5, i % 2 == 0 and p.Accent or p.Muted)
			end
		elseif name == "Notch" then
			local pill = Box(parent, 30, 4, 120, 20, p.Secondary, 10)
			New("UIStroke", pill, {Color = p.Accent, Thickness = 1})
			for i = 0, 3 do Box(pill, 8 + i * 24, 4, 18, 12, i == 0 and p.Accent or p.Row, 6) end
			local sheet = Box(parent, 20, 30, 140, 100, p.Background, 10)
			New("UIStroke", sheet, {Color = p.Border, Thickness = 1})
			for i = 1, 4 do Box(sheet, 10, 8 + (i - 1) * 22, 120, 16, p.Row, 5) end
		elseif name == "HUDStrip" then
			local strip = Box(parent, 10, 118, 160, 24, p.Background, 12)
			New("UIStroke", strip, {Color = p.Accent, Thickness = 1})
			for i = 0, 3 do Box(strip, 8 + i * 38, 6, 32, 12, p.Row, 4) end
			local panel = Box(parent, 30, 20, 120, 90, p.Secondary, 8)
			New("UIStroke", panel, {Color = p.Border, Thickness = 1})
			for i = 1, 3 do Box(panel, 8, 8 + (i - 1) * 26, 104, 18, p.Row, 5) end
		elseif name == "Radial" then
			local ring = Box(parent, 20, 15, 120, 120, p.Secondary, 60)
			New("UIStroke", ring, {Color = p.Accent, Thickness = 1.5})
			Box(ring, 44, 44, 32, 32, p.Background, 16)
			for i = 0, 5 do
				local a = math.rad(-90 + i * 60)
				Box(ring, 60 + math.cos(a) * 46 - 8, 60 + math.sin(a) * 46 - 8, 16, 16, i == 0 and p.Accent or p.Row, 8)
			end
			Box(parent, 148, 20, 32, 110, p.Background, 6)
		end
	end

	local picked = false
	for _, name in ipairs(names) do
		local pref = SkinThemes[name]
		local p = {}
		for k, v in pairs(Themes[pref[1]]) do p[k] = v end
		if AccentColors[pref[2]] then p.Accent = AccentColors[pref[2]] end
		local card = Round(New("TextButton", cardsHolder, {Size = UDim2.fromOffset(200,320), BackgroundColor3 = p.Background, Text = "", AutoButtonColor = false, BorderSizePixel = 0}), 14)
		local stroke = New("UIStroke", card, {Color = p.Border, Thickness = 1.5})
		local pv = New("Frame", card, {Position = UDim2.fromOffset(10,10), Size = UDim2.fromOffset(180,150), BackgroundColor3 = p.Secondary, BorderSizePixel = 0, ClipsDescendants = true})
		New("UICorner", pv, {CornerRadius = UDim.new(0,8)})
		Preview(name, pv, p)
		New("TextLabel", card, {Position = UDim2.fromOffset(0,172), Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1, Text = string.upper(name), TextColor3 = p.Text, Font = GOTHB, TextSize = 16})
		New("TextLabel", card, {Position = UDim2.fromOffset(0,198), Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, Text = descs[name], TextColor3 = p.SubText, Font = GOTHM, TextSize = 11})
		local sel = Round(New("Frame", card, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,222), Size = UDim2.fromOffset(120,26), BackgroundColor3 = p.Accent, BorderSizePixel = 0}), 8)
		New("TextLabel", sel, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "SELECT", TextColor3 = p.Background, Font = GOTHB, TextSize = 12})

		local iconHolder = New("Frame", card, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,258), Size = UDim2.fromOffset(40,40), BackgroundTransparency = 1})
		local iconScale = New("UIScale", iconHolder, {Scale = 1})
		local icon = Round(New("Frame", iconHolder, {AnchorPoint = Vector2.new(0.5,0), Size = UDim2.fromOffset(40,40), BackgroundColor3 = p.Secondary, BorderSizePixel = 0, ClipsDescendants = true, BackgroundTransparency = 0.35}), 8)
		local iconStroke = New("UIStroke", icon, {Color = p.Border, Thickness = 1, Transparency = 0.3})
		local iconInner = New("Frame", icon, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(180,150), BackgroundTransparency = 1})
		local iconInnerScale = New("UIScale", iconInner, {Scale = 40 / 180})
		Preview(name, iconInner, p)
		card.MouseEnter:Connect(function()
			Tween(stroke, {Color = p.Accent, Thickness = 2.5}, 0.15)
			Tween(iconScale, {Scale = 1.6}, 0.16, Enum.EasingStyle.Back)
			Tween(icon, {BackgroundTransparency = 0}, 0.16)
			Tween(iconStroke, {Color = p.Accent, Transparency = 0}, 0.16)
		end)
		card.MouseLeave:Connect(function()
			Tween(stroke, {Color = p.Border, Thickness = 1.5}, 0.15)
			Tween(iconScale, {Scale = 1}, 0.16)
			Tween(icon, {BackgroundTransparency = 0.35}, 0.16)
			Tween(iconStroke, {Color = p.Border, Transparency = 0.3}, 0.16)
		end)
		card.MouseButton1Click:Connect(function()
			if picked then return end
			picked = true
			DebugLog.Push("system", "menu selected: " .. name)
			Tween(dim, {BackgroundTransparency = 1}, 0.25)
			Tween(holder, {GroupTransparency = 1}, 0.25)
			task.delay(0.28, function()
				gui:Destroy()
				onPick(name)
			end)
		end)
	end

	closeAll.MouseButton1Click:Connect(function()
		if picked then return end
		picked = true
		DebugLog.Push("system", "menu picker closed by user, script terminated")
		gui:Destroy()
	end)
end

local function RunKeySystem(onSuccess)
	local gui = New("ScreenGui", PlayerGui, {Name = "VortexAuth", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100})
	local dim = New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true})
	local card = Round(New("CanvasGroup", gui, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(380,310),
		BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1}), 14)
	local scale = New("UIScale", card, {Scale = 0.9})
	local glow = GlowStroke(card)

	local closeAuth = Round(New("TextButton", card, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,14), Size = UDim2.fromOffset(26,26), BackgroundColor3 = "@Row",
		Text = "X", TextColor3 = Color3.fromRGB(255,90,100), Font = GOTHB, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0}), 7)
	closeAuth.MouseEnter:Connect(function() Tween(closeAuth, {BackgroundColor3 = Theme.Border}, 0.12) end)
	closeAuth.MouseLeave:Connect(function() Tween(closeAuth, {BackgroundColor3 = Theme.Row}, 0.12) end)
	closeAuth.MouseButton1Click:Connect(function()
		DebugLog.Push("system", "auth window closed by user, script terminated")
		Tween(dim, {BackgroundTransparency = 1}, 0.2)
		Tween(card, {GroupTransparency = 1}, 0.2)
		task.delay(0.22, function() glow:Cancel(); gui:Destroy(); table.clear(Refreshers) end)
	end)

	New("TextLabel", card, {Position = UDim2.fromOffset(0,28), Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, Text = "VORTEX", TextColor3 = "@Text", Font = GOTHB, TextSize = 26})
	New("TextLabel", card, {Position = UDim2.fromOffset(0,60), Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, Text = "SECURE ACCESS", TextColor3 = "@Accent", Font = GOTHM, TextSize = 11})

	local account = Round(New("Frame", card, {Position = UDim2.fromOffset(30,100), Size = UDim2.new(1,-60,0,40), BackgroundColor3 = "@Row", BorderSizePixel = 0}), 8)
	New("TextLabel", account, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(0.4,0,1,0), BackgroundTransparency = 1, Text = "ACCOUNT", TextColor3 = "@Muted", Font = GOTHB, TextSize = 10, TextXAlignment = LEFT})
	New("TextLabel", account, {Position = UDim2.new(0.4,0,0,0), Size = UDim2.new(0.6,-14,1,0), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = "@Text",
		Font = GOTHM, TextSize = 12, TextXAlignment = RIGHT, TextTruncate = Enum.TextTruncate.AtEnd})

	local inputRow = Round(New("Frame", card, {Position = UDim2.fromOffset(30,150), Size = UDim2.new(1,-60,0,40), BackgroundColor3 = "@Row", BorderSizePixel = 0}), 8)
	local inputStroke = New("UIStroke", inputRow, {Color = "@Border", Thickness = 1})

	local RealInput, LastMasked, Guard = "", "", false
	local box = New("TextBox", inputRow, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,-28,1,0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Enter access key",
		PlaceholderColor3 = "@Muted", TextColor3 = "@Text", Font = GOTHM, TextSize = 13, TextXAlignment = LEFT, ClearTextOnFocus = false})
	local function SyncMask()
		local masked = string.rep("*", #RealInput)
		LastMasked = masked
		Guard = true
		box.Text = masked
		box.CursorPosition = #masked + 1
		Guard = false
	end
	box:GetPropertyChangedSignal("Text"):Connect(function()
		if Guard then return end
		local shown = box.Text
		if shown == LastMasked then return end
		if #shown > #LastMasked then
			local added = string.gsub(string.sub(shown, #LastMasked + 1), "%*", "")
			RealInput ..= added
		else
			RealInput = string.sub(RealInput, 1, math.max(#RealInput - (#LastMasked - #shown), 0))
		end
		SyncMask()
	end)

	local button = Round(New("TextButton", card, {Position = UDim2.fromOffset(30,204), Size = UDim2.new(1,-60,0,40), BackgroundColor3 = "@Accent", Text = "AUTHORIZE",
		TextColor3 = "@Background", Font = GOTHB, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0}), 8)
	local status = New("TextLabel", card, {Position = UDim2.fromOffset(30,256), Size = UDim2.new(1,-60,0,30), BackgroundTransparency = 1, Text = "Enter your personal key",
		TextColor3 = "@SubText", Font = GOTHM, TextSize = 12, TextWrapped = true})

	local success, danger = Color3.fromRGB(90,220,140), Color3.fromRGB(255,90,100)
	local attempts, locked, busy = 0, false, false
	local function SetStatus(text, color) status.Text = text; Tween(status, {TextColor3 = color}, 0.2) end
	local function Shake()
		for _, off in ipairs({-10, 10, -6, 6, 0}) do
			if not card.Parent then return end
			card.Position = UDim2.new(0.5, off, 0.5, 0)
			task.wait(0.045)
		end
	end
	local function Lock()
		locked = true
		task.spawn(function()
			for remaining = 30, 1, -1 do
				if not gui.Parent then return end
				SetStatus("Too many attempts. Retry in " .. remaining .. "s", danger)
				task.wait(1)
			end
			if not gui.Parent then return end
			attempts, locked = 0, false
			SetStatus("Enter your personal key", Theme.SubText)
		end)
	end
	local function Submit()
		if locked or busy then return end
		local ok, reason = Authorize(RealInput)
		if ok then
			DebugLog.Push("auth", "access granted for " .. LocalPlayer.Name)
			busy = true
			SetStatus("Access granted", success)
			Tween(button, {BackgroundColor3 = success}, 0.2)
			task.delay(0.6, function()
				Tween(card, {GroupTransparency = 1}, 0.3)
				Tween(scale, {Scale = 1.06}, 0.3)
				Tween(dim, {BackgroundTransparency = 1}, 0.3)
				task.delay(0.35, function()
					glow:Cancel()
					gui:Destroy()
					table.clear(Refreshers)
					onSuccess()
				end)
			end)
		else
			attempts += 1
			DebugLog.Push("auth", "access denied for " .. LocalPlayer.Name .. " (" .. reason .. ")")
			SetStatus(reason, danger)
			task.spawn(Shake)
			if attempts >= 5 then
				DebugLog.Push("auth", "lockout triggered after " .. attempts .. " failed attempts")
				Lock()
			end
		end
	end
	box.Focused:Connect(function() Tween(inputStroke, {Color = Theme.Accent}, 0.15) end)
	box.FocusLost:Connect(function(enter)
		Tween(inputStroke, {Color = Theme.Border}, 0.15)
		if enter then Submit() end
	end)
	button.MouseEnter:Connect(function() Tween(button, {BackgroundTransparency = 0.2}, 0.12) end)
	button.MouseLeave:Connect(function() Tween(button, {BackgroundTransparency = 0}, 0.12) end)
	button.MouseButton1Click:Connect(Submit)

	Tween(dim, {BackgroundTransparency = 0.45}, 0.4)
	Tween(card, {GroupTransparency = 0}, 0.35)
	Tween(scale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
end

local function RunEula(onAccept)
	local gui = New("ScreenGui", PlayerGui, {Name = "VortexEula", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100})
	local dim = New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true})
	local card = Round(New("CanvasGroup", gui, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(460,420),
		BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1}), 14)
	local scale = New("UIScale", card, {Scale = 0.9})
	local glow = GlowStroke(card)

	New("TextLabel", card, {Position = UDim2.fromOffset(0,24), Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1, Text = "USER AGREEMENT", TextColor3 = "@Text", Font = GOTHB, TextSize = 20})
	New("TextLabel", card, {Position = UDim2.fromOffset(0,52), Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, Text = "READ BEFORE CONTINUING", TextColor3 = "@Accent", Font = GOTHM, TextSize = 11})

	local body = Round(New("ScrollingFrame", card, {Position = UDim2.fromOffset(24,84), Size = UDim2.new(1,-48,0,246), BackgroundColor3 = "@Row", BorderSizePixel = 0,
		ScrollBarThickness = 4, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y}), 8)
	New("UIPadding", body, {PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14), PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12)})
	New("UIListLayout", body, {Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder})

	local EulaClauses = {
		"This software is provided to you personally and is licensed, not sold. Access is tied to your key and account; it is not transferable.",
		"Cracking, reverse-engineering, or bypassing the key/authorization system is prohibited. Any attempt to do so voids access immediately and permanently.",
		"Redistribution, resale, re-hosting, or public sharing of this software, in whole or in part, modified or unmodified, is prohibited without explicit written permission.",
		"Sharing your access key with any other person is prohibited. A shared key is treated the same as a cracked one.",
		"You are solely responsible for how and where you use this software, including any consequences within a game, platform, or service (bans, restrictions, account action).",
		"This software is provided \"as is\" with no warranty of any kind, express or implied, including fitness for a particular purpose or non-infringement.",
		"Continued use after any update constitutes acceptance of that update's terms as presented at that time.",
	}
	for i, text in ipairs(EulaClauses) do
		local row = New("Frame", body, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = i})
		New("TextLabel", row, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			Text = string.format("%d.  %s", i, text), TextColor3 = "@SubText", Font = GOTHM, TextSize = 12, TextWrapped = true, TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top})
	end

	local agreeRow = New("Frame", card, {Position = UDim2.fromOffset(24,340), Size = UDim2.new(1,-48,0,26), BackgroundTransparency = 1})
	local agreed = false
	local check = Round(New("TextButton", agreeRow, {Size = UDim2.fromOffset(20,20), BackgroundColor3 = "@Row", Text = "", AutoButtonColor = false, BorderSizePixel = 0}), 5)
	local checkStroke = New("UIStroke", check, {Color = "@Border", Thickness = 1.5})
	local checkMark = New("TextLabel", check, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "✓", TextColor3 = "@Background", Font = GOTHB, TextSize = 14, TextTransparency = 1})
	New("TextLabel", agreeRow, {Position = UDim2.fromOffset(30,0), Size = UDim2.new(1,-30,1,0), BackgroundTransparency = 1, Text = "I have read and agree to the terms above",
		TextColor3 = "@SubText", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT})

	local button = Round(New("TextButton", card, {Position = UDim2.fromOffset(24,378), Size = UDim2.new(1,-48,0,26), BackgroundColor3 = "@Row", Text = "AGREE AND CONTINUE",
		TextColor3 = "@Background", Font = GOTHB, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0}), 7)

	local function SetAgreed(v)
		agreed = v
		Tween(check, {BackgroundColor3 = agreed and Theme.Accent or Theme.Row}, 0.12)
		Tween(checkMark, {TextTransparency = agreed and 0 or 1}, 0.12)
		Tween(button, {BackgroundColor3 = agreed and Theme.Accent or Theme.Row, TextColor3 = agreed and Theme.Background or Theme.SubText}, 0.15)
	end
	check.MouseButton1Click:Connect(function() SetAgreed(not agreed) end)

	local closed = false
	button.MouseButton1Click:Connect(function()
		if not agreed or closed then return end
		closed = true
		DebugLog.Push("eula", "terms accepted by " .. LocalPlayer.Name)
		Tween(dim, {BackgroundTransparency = 1}, 0.25)
		Tween(card, {GroupTransparency = 1}, 0.25)
		task.delay(0.3, function()
			glow:Cancel()
			gui:Destroy()
			table.clear(Refreshers)
			onAccept()
		end)
	end)

	Tween(dim, {BackgroundTransparency = 0.45}, 0.4)
	Tween(card, {GroupTransparency = 0}, 0.35)
	Tween(scale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
end

local function ProceedPastEula()
	DebugLog.Push("system", "menu picker presented")
	RunMenuPicker(function(skin)
		local ok, err = pcall(LaunchHub, skin)
		if not ok then
			DebugLog.Push("system", "hub launch error: " .. tostring(err), true)
			warn("[Vortex] " .. tostring(err))
		end
	end)
end

DebugLog.Push("system", "auth gate presented")
RunKeySystem(function()
	if LoadSetting("eula_accepted", "0") == "1" then
		DebugLog.Push("system", "eula previously accepted, skipping")
		ProceedPastEula()
		return
	end
	DebugLog.Push("system", "eula presented")
	RunEula(function()
		SaveSetting("eula_accepted", "1")
		ProceedPastEula()
	end)
end)

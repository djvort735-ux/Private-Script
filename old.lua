local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- Forward declaration: early Tween/ApplyTheme error paths use this local.
local DebugLog

local Env = (getgenv and getgenv()) or _G
if type(Env.VortexUnload) == "function" then pcall(Env.VortexUnload); Env.VortexUnload = nil end

local Locale = {Current = "EN", Registry = {}, Listeners = {}, Strings = {EN = {}, UA = {}, RU = {}}}
local function L(k, en, ua, ru) Locale.Strings.EN[k] = en; Locale.Strings.UA[k] = ua; Locale.Strings.RU[k] = ru end

L("APP_NAME","VORTEX","VORTEX","VORTEX")
L("APP_SUB","COMBAT HUB","БОЙОВИЙ ХАБ","БОЕВОЙ ХАБ")
L("TAB_AIMBOT","AIMBOT","АЙМБОТ","АИМБОТ")
L("TAB_VISUALS","VISUALS","ВІЗУАЛ","ВИЗУАЛ")
L("TAB_ESP","ESP","ESP","ESP")
L("TAB_TRIGGERBOT","TRIGGERBOT","ТРИГЕРБОТ","ТРИГГЕРБОТ")
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
L("SEC_TEXTCOLORS","TEXT COLORS","КОЛЬОРИ ТЕКСТУ","ЦВЕТА ТЕКСТА")
L("LBL_AUTOTEXT","AUTO TEXT CONTRAST","АВТО-КОНТРАСТ ТЕКСТА","АВТО-КОНТРАСТ ТЕКСТА")
L("LBL_LIMB","LIMB LABEL","ЧАСТИНА ТІЛА","ЧАСТЬ ТЕЛА")
L("SEC_ELEMCOLORS","ELEMENT COLORS","КОЛЬОРИ ЕЛЕМЕНТІВ","ЦВЕТА ЭЛЕМЕНТОВ")
L("BTN_RESETTEXT","RESET TEXT COLORS","СКИНУТИ КОЛЬОРИ ТЕКСТУ","СБРОСИТЬ ЦВЕТА ТЕКСТА")
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
L("OPT_ITEMESP","Item ESP","ESP предметів","ESP предметов")
L("OPT_WORLDWEAPONESP","World Weapon ESP","ESP зброї","ESP оружия")
L("OPT_WORLDESPDIST","World ESP Distance","Дистанція світового ESP","Дистанция мирового ESP")
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
L("SEC_QOL","QUALITY OF LIFE","ЯКІСТЬ ЖИТТЯ","КАЧЕСТВО ЖИЗНИ")
L("OPT_MENUSTYLE","Menu Style","Стиль меню","Стиль меню")
L("OPT_ANTIAFK","Anti-AFK","Анти-АФК","Анти-АФК")
L("OPT_CLICKTP","Ctrl+Click Teleport","Телепорт по Ctrl+клік","Телепорт по Ctrl+клик")
L("OPT_FPSCAP","FPS Cap","Ліміт FPS","Лимит FPS")
L("OPT_FPSCAPVAL","FPS Cap Value","Значення ліміту FPS","Значение лимита FPS")
L("BTN_HOPSERVER","HOP SERVER","ЗМІНИТИ СЕРВЕР","СМЕНИТЬ СЕРВЕР")
L("TOAST_HOPQUEUED","Server hop queued","Перехід на сервер у черзі","Переход на сервер в очереди")
L("TOAST_HOPFAIL","No alternate server found","Інший сервер не знайдено","Другой сервер не найден")
L("TOAST_FPSCAPFAIL","setfpscap unavailable on this executor","setfpscap недоступний у цьому executor","setfpscap недоступен в этом executor")
L("SEC_ADVANCED","ADVANCED","РОЗШИРЕНІ","РАСШИРЕННЫЕ")
L("SEC_VISUAL_ADV","VISUAL / ADVANCED","ВІЗУАЛ / РОЗШИРЕНІ","ВИЗУАЛ / РАСШИРЕННЫЕ")
L("SEC_MOVEMENT_ADV","MOVEMENT ADVANCED","РОЗШИРЕНИЙ РУХ","РАСШИРЕННОЕ ДВИЖЕНИЕ")
L("SEC_CAMERA_ADV","CAMERA ADVANCED","РОЗШИРЕНА КАМЕРА","РАСШИРЕННАЯ КАМЕРА")
L("SEC_ESP_ADV","ESP ADVANCED","РОЗШИРЕНИЙ ESP","РАСШИРЕННЫЙ ESP")
L("SEC_TRIGGER_ADV","TRIGGER ADVANCED","РОЗШИРЕНИЙ ТРИГЕР","РАСШИРЕННЫЙ ТРИГГЕР")
L("SEC_RENDER_PRESETS","RENDER PRESETS","ПРЕСЕТИ РЕНДЕРИНГУ","ПРЕСЕТЫ РЕНДЕРИНГА")
L("SEC_BIND_MODES","BIND MODES","РЕЖИМИ КЛАВІШ","РЕЖИМЫ КЛАВИШ")
L("SEC_CONFIG_TOOLS","CONFIG TOOLS","ІНСТРУМЕНТИ КОНФІГУ","ИНСТРУМЕНТЫ КОНФИГА")
L("SEC_DEBUG_ADV","DEBUG / PERFORMANCE","ДЕБАГ / ПРОДУКТИВНІСТЬ","ДЕБАГ / ПРОИЗВОДИТЕЛЬНОСТЬ")
L("LBL_BIND_CONFLICTS","Bind conflicts","Конфлікти клавіш","Конфликты клавиш")
L("LBL_BIND_MODE","Bind mode","Режим клавіші","Режим клавиши")
L("LBL_TARGET","Target","Ціль","Цель")
L("LBL_TARGET_NONE","No target","Немає цілі","Нет цели")
L("LBL_SPEED","Speed","Швидкість","Скорость")
L("LBL_COORDS","Coordinates","Координати","Координаты")
L("LBL_SERVER","Server","Сервер","Сервер")
L("LBL_PLAYERS","Players","Гравці","Игроки")
L("LBL_PRED_H","Horizontal Prediction","Горизонтальний прогноз","Горизонтальный прогноз")
L("LBL_PRED_V","Vertical Prediction","Вертикальний прогноз","Вертикальный прогноз")
L("LBL_FOV_SCALE","Distance FOV Scale","Масштаб FOV за дистанцією","Масштаб FOV по дистанции")
L("LBL_TRIGGER_BODY","Trigger Body Mode","Режим частини тригера","Режим части триггера")
L("LBL_PLAYER_ESP","Player ESP","ESP гравців","ESP игроков")
L("LBL_HEALTH_GRADIENT","Health Gradient","Градієнт здоров'я","Градиент здоровья")
L("LBL_DISTANCE","Distance","Відстань","Дистанция")
L("LBL_HEALTH","Health","Здоров'я","Здоровье")
L("BTN_DELETE","DELETE CONFIG","ВИДАЛИТИ КОНФІГ","УДАЛИТЬ КОНФИГ")
L("BTN_RENAME","RENAME CONFIG","ПЕРЕЙМЕНУВАТИ","ПЕРЕИМЕНОВАТЬ")
L("BTN_COPY","COPY CONFIG","КОПІЮВАТИ","КОПИРОВАТЬ")
L("BTN_JSON_EXPORT","JSON EXPORT","JSON ЕКСПОРТ","JSON ЭКСПОРТ")
L("BTN_JSON_IMPORT","JSON IMPORT","JSON ІМПОРТ","JSON ИМПОРТ")
L("BTN_REJOIN","REJOIN","ПЕРЕЗАЙТИ","ПЕРЕЗАЙТИ")
L("BTN_COPY_JOB","COPY JOB ID","КОПІЮВАТИ JOB ID","КОПИРОВАТЬ JOB ID")
L("BTN_COPY_SERVER","COPY SERVER INFO","КОПІЮВАТИ ДАНІ СЕРВЕРА","КОПИРОВАТЬ ДАННЫЕ СЕРВЕРА")
L("BTN_COPY_LOG","COPY LOG","КОПІЮВАТИ ЛОГ","КОПИРОВАТЬ ЛОГ")
L("BTN_EXPORT_LOG","EXPORT LOG","ЕКСПОРТ ЛОГУ","ЭКСПОРТ ЛОГА")
L("LBL_AIM_PRIORITY","Target Priority","Пріоритет цілі","Приоритет цели")
L("LBL_TARGET_PART","Target Part","Частина цілі","Часть цели")
L("LBL_FOV_DYNAMIC","Dynamic FOV","Динамічний FOV","Динамический FOV")
L("LBL_TARGET_LOCK","Target Lock","Фіксація цілі","Фиксация цели")
L("LBL_SWITCH_DELAY","Switch Delay","Затримка перемикання","Задержка переключения")
L("LBL_PRED_MULT","Prediction Multiplier","Множник прогнозу","Множитель прогноза")
L("LBL_AIM_ACCEL","Aim Acceleration","Прискорення прицілу","Ускорение прицела")
L("LBL_AIM_DECEL","Aim Deceleration","Гальмування прицілу","Торможение прицела")
L("LBL_AIM_SMOOTH","Aim Smoothing","Плавність прицілу","Плавность прицела")
L("LBL_TRIGGER_PRIORITY","Trigger Priority","Пріоритет тригера","Приоритет триггера")
L("LBL_TRIGGER_MIN","Min Fire Interval","Мін. інтервал вогню","Мин. интервал огня")
L("LBL_TRIGGER_MAX","Max Fire Interval","Макс. інтервал вогню","Макс. интервал огня")
L("LBL_TRIGGER_RANDOM","Random Reaction","Випадкова реакція","Случайная реакция")
L("LBL_TRIGGER_BURST","Burst Mode","Режим черги","Режим очереди")
L("LBL_TRIGGER_COOLDOWN","Cooldown Indicator","Індикатор кулдауну","Индикатор кулдауна")
L("LBL_NPC","NPC","NPC","NPC")
L("LBL_BOT","Bot","Бот","Бот")
L("LBL_HEALTH_PERCENT","Health Percent","Відсоток здоров'я","Процент здоровья")
L("LBL_VISIBILITY_COLOR","Visibility Color","Колір видимості","Цвет видимости")
L("LBL_DYNAMIC_COLOR","Dynamic Color","Динамічний колір","Динамический цвет")
L("LBL_RAINBOW","Rainbow","Веселка","Радуга")
L("LBL_AIRWALK","Air Walk","Ходьба по повітрю","Ходьба по воздуху")
L("LBL_NO_FALL","No Fall","Без шкоди від падіння","Без урона от падения")
L("LBL_BHOP","Bunny Hop","Баніхоп","Банихоп")
L("LBL_CAMERA_SMOOTH","Camera Smoothing","Плавність камери","Плавность камеры")
L("LBL_FOV_TRANS","FOV Transition","Перехід FOV","Переход FOV")
L("LBL_CAMERA_SHAKE","Camera Shake","Тремтіння камери","Тряска камеры")
L("LBL_DEBUG_MODE","Debug Mode","Режим дебагу","Режим дебага")
L("LBL_PERF_MODE","Performance Mode","Режим продуктивності","Режим производительности")
L("LBL_MOUSE_BIND","Mouse Bind","Клавіша миші","Клавиша мыши")
L("LBL_LAYOUT_PRESET","Layout preset","Пресет макета","Пресет макета")
L("LBL_BURST_COUNT","Burst Count","Кількість у черзі","Количество в очереди")
L("LBL_BURST_DELAY","Burst Delay","Затримка черги","Задержка очереди")
L("LBL_CROSS_STYLE","Crosshair Style","Стиль прицілу","Стиль прицела")
L("LBL_CROSS_LENGTH","Crosshair Length","Довжина прицілу","Длина прицела")
L("LBL_CROSS_ROTATION","Crosshair Rotation","Поворот прицілу","Поворот прицела")
L("LBL_CROSS_OUTLINE","Crosshair Outline","Контур прицілу","Контур прицела")
L("LBL_OUTLINE_THICKNESS","Outline Thickness","Товщина контуру","Толщина контура")
L("LBL_CROSS_SPREAD","Crosshair Spread","Розкид прицілу","Разброс прицела")
L("LBL_SPREAD_SPEED","Spread Speed","Швидкість розкиду","Скорость разброса")
L("LBL_SHAKE_INTENSITY","Shake Intensity","Сила тремтіння","Сила тряски")
L("LBL_SHAKE_SPEED","Shake Speed","Швидкість тремтіння","Скорость тряски")
L("LBL_ESP_BUDGET","ESP Update Budget","Ліміт оновлень ESP","Лимит обновлений ESP")
L("LBL_BHOP_INTERVAL","Bunny Hop Interval","Інтервал баніхопа","Интервал банихопа")
L("LBL_FORWARD_KEY","Forward Key","Клавіша вперед","Клавиша вперёд")
L("LBL_BACK_KEY","Back Key","Клавіша назад","Клавиша назад")
L("LBL_LEFT_KEY","Left Key","Клавіша вліво","Клавиша влево")
L("LBL_RIGHT_KEY","Right Key","Клавіша вправо","Клавиша вправо")
L("LBL_UP_KEY","Up Key","Клавіша вгору","Клавиша вверх")
L("LBL_DOWN_KEY","Down Key","Клавіша вниз","Клавиша вниз")
L("LBL_RENAME_TO","Rename To","Нова назва","Новое имя")
L("PH_RENAME","new config name","нова назва конфігу","новое имя конфига")
L("TOAST_CONFIGCOPY","Config copied","Конфіг скопійовано","Конфиг скопирован")
L("TOAST_CONFIGDELETE","Config deleted","Конфіг видалено","Конфиг удалён")
L("TOAST_CONFIGRENAME","Config renamed","Конфіг перейменовано","Конфиг переименован")
L("TOAST_CLIPBOARDFAIL","Clipboard unavailable","Буфер обміну недоступний","Буфер обмена недоступен")
L("TOAST_TPBLOCKED","Disable noclip first","Спершу вимкніть ноукліп","Сначала отключите ноуклип")

L("LBL_BURST_COUNT","Burst Count","Кількість у черзі","Количество в очереди")
L("LBL_BURST_DELAY","Burst Delay","Затримка черги","Задержка очереди")
L("LBL_CROSS_STYLE","Crosshair Style","Стиль прицілу","Стиль прицела")
L("LBL_CROSS_LENGTH","Crosshair Length","Довжина прицілу","Длина прицела")
L("LBL_CROSS_ROTATION","Crosshair Rotation","Поворот прицілу","Поворот прицела")
L("LBL_CROSS_OUTLINE","Crosshair Outline","Контур прицілу","Контур прицела")
L("LBL_OUTLINE_THICKNESS","Outline Thickness","Товщина контуру","Толщина контура")
L("LBL_CROSS_SPREAD","Crosshair Spread","Розкид прицілу","Разброс прицела")
L("LBL_SPREAD_SPEED","Spread Speed","Швидкість розкиду","Скорость разброса")
L("LBL_SHAKE_INTENSITY","Shake Intensity","Сила тремтіння","Сила тряски")
L("LBL_SHAKE_SPEED","Shake Speed","Швидкість тремтіння","Скорость тряски")
L("LBL_ESP_BUDGET","ESP Update Budget","Ліміт оновлень ESP","Лимит обновлений ESP")
L("LBL_BHOP_INTERVAL","Bunny Hop Interval","Інтервал баніхопа","Интервал банихопа")
L("LBL_FORWARD_KEY","Forward Key","Клавіша вперед","Клавиша вперёд")
L("LBL_BACK_KEY","Back Key","Клавіша назад","Клавиша назад")
L("LBL_LEFT_KEY","Left Key","Клавіша вліво","Клавиша влево")
L("LBL_RIGHT_KEY","Right Key","Клавіша вправо","Клавиша вправо")
L("LBL_UP_KEY","Up Key","Клавіша вгору","Клавиша вверх")
L("LBL_DOWN_KEY","Down Key","Клавіша вниз","Клавиша вниз")
L("LBL_RENAME_TO","Rename To","Нова назва","Новое имя")
L("PH_RENAME","new config name","нова назва конфігу","новое имя конфига")
L("LBL_RENDER_PRESET","Render Preset","Пресет рендерингу","Пресет рендеринга")
L("LBL_TEAM_COLORS","Team Colors","Кольори команд","Цвета команд")
L("LBL_KILL_MARKER","Kill Marker","Маркер вбивства","Маркер убийства")
L("LBL_COPY_LOG","Copy Log","Копіювати лог","Копировать лог")
L("BTN_EXPORT_LOG","EXPORT LOG","ЕКСПОРТ ЛОГУ","ЭКСПОРТ ЛОГА")
L("LBL_TARGET_NONE","None","Немає","Нет")
L("LBL_TARGET","Target","Ціль","Цель")
L("LBL_FPS","FPS","FPS","ФПС")
L("LBL_PING","Ping","Пінг","Пинг")
L("LBL_SPEED","Speed","Швидкість","Скорость")
L("LBL_COORDS","Coordinates","Координати","Координаты")
L("LBL_SERVER","Server","Сервер","Сервер")
L("LBL_PLAYERS","Players","Гравці","Игроки")
L("SEC_ESP_ADV","ESP ADVANCED","РОЗШИРЕНИЙ ESP","РАСШИРЕННЫЙ ESP")
L("SEC_TRIGGER_ADV","TRIGGER ADVANCED","РОЗШИРЕНИЙ ТРИГЕР","РАСШИРЕННЫЙ ТРИГГЕР")
L("SEC_MOVEMENT_ADV","MOVEMENT ADVANCED","РОЗШИРЕНИЙ РУХ","РАСШИРЕННОЕ ДВИЖЕНИЕ")
L("SEC_CAMERA_ADV","CAMERA ADVANCED","РОЗШИРЕНА КАМЕРА","РАСШИРЕННАЯ КАМЕРА")
L("SEC_RENDER_PRESETS","RENDER PRESETS","ПРЕСЕТИ РЕНДЕРИНГУ","ПРЕСЕТЫ РЕНДЕРИНГА")
L("SEC_DEBUG_ADV","DEBUG ADVANCED","РОЗШИРЕНИЙ DEBUG","РАСШИРЕННЫЙ DEBUG")
L("SEC_BIND_MODES","BIND MODES","РЕЖИМИ КЛАВІШ","РЕЖИМЫ КЛАВИШ")
L("SEC_CONFIG_TOOLS","CONFIG TOOLS","ІНСТРУМЕНТИ КОНФІГУ","ИНСТРУМЕНТЫ КОНФИГА")
L("LBL_ESP_VISIBLE_COLOR","Visible-target color","Колір видимої цілі","Цвет видимой цели")
L("LBL_ESP_HIDDEN_COLOR","Hidden-target color","Колір прихованої цілі","Цвет скрытой цели")
L("LBL_RAINBOW_SPEED","Rainbow speed","Швидкість райдуги","Скорость радуги")
L("LBL_FOV_COLOR","FOV color","Колір FOV","Цвет FOV")
L("LBL_TARGET_INDICATOR","Target indicator","Індикатор цілі","Индикатор цели")
L("LBL_TARGET_HIGHLIGHT","Target highlight","Підсвічування цілі","Подсветка цели")

function Locale.T(key)
	local set = Locale.Strings[Locale.Current]
	return (set and set[key]) or Locale.Strings.EN[key] or key
end
function Locale.Bind(inst, key, prop)
	prop = prop or "Text"
	if not inst then return end
	for i = #Locale.Registry, 1, -1 do
		local e = Locale.Registry[i]
		if e.Instance == inst and e.Property == prop then
			e.Key = key
			pcall(function() inst[prop] = Locale.T(key) end)
			return e
		end
	end
	local entry = {Instance = inst, Key = key, Property = prop}
	table.insert(Locale.Registry, entry)
	pcall(function() inst[prop] = Locale.T(key) end)
	return entry
end
function Locale.OnChange(cb)
	if type(cb) ~= "function" then return function() end end
	for _, old in ipairs(Locale.Listeners) do
		if old == cb then return function() end end
	end
	table.insert(Locale.Listeners, cb)
	local active = true
	return function()
		if not active then return end
		active = false
		for i = #Locale.Listeners, 1, -1 do if Locale.Listeners[i] == cb then table.remove(Locale.Listeners, i); break end end
	end
end
function Locale.SetImmediate(code)
	if not Locale.Strings[code] then return false end
	Locale.Current = code
	for i = #Locale.Registry, 1, -1 do
		local e = Locale.Registry[i]
		local ok, parent = pcall(function() return e.Instance and e.Instance.Parent end)
		if not ok or parent == nil then
			table.remove(Locale.Registry, i)
		else
			pcall(function() e.Instance[e.Property] = Locale.T(e.Key) end)
		end
	end
	for _, cb in ipairs(Locale.Listeners) do
		task.spawn(function() pcall(cb) end)
	end
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

local CoreGui = game:GetService("CoreGui")
local function ResolveVortexGuiHost()
	local ok, host = pcall(function()
		local test = Instance.new("ScreenGui")
		test.Name = "VortexCoreProbe"
		test.ResetOnSpawn = false
		test.Parent = CoreGui
		local parent = test.Parent
		test:Destroy()
		return parent
	end)
	if ok and host then return host, "CoreGui" end
	local gh = rawget(_G, "gethui")
	if type(gh) == "function" then
		local ok2, h = pcall(gh)
		if ok2 and h then return h, "gethui" end
	end
	return PlayerGui, "PlayerGui"
end
local VortexGuiHost, VortexGuiHostKind = ResolveVortexGuiHost()
-- ESP host: gethui() when the executor has it (hidden, not CoreGui), otherwise PlayerGui.
local EspHost = (function()
	local gh = rawget(_G, "gethui")
	if gh then
		local ok, h = pcall(gh)
		if ok and h then return h end
	end
	return PlayerGui
end)()
for _, host in ipairs({PlayerGui, CoreGui, VortexGuiHost, EspHost}) do
	for _, name in ipairs({"VortexAuth", "VortexOverlay", "VortexESP", "VortexMenu", "VortexCursor", "VortexCustomCursor", "VortexThemePick", "VortexMenuPick"}) do
		local ok, old = pcall(function() return host:FindFirstChild(name) end)
		if ok and old then pcall(function() old:Destroy() end) end
	end
end

local ThemeKeys = {"Background", "Secondary", "Row", "Border", "Text", "SubText", "Muted", "Accent"}
local function Pal(...)
	local a, t = {...}, {}
	for i, k in ipairs(ThemeKeys) do t[k] = Color3.fromRGB(table.unpack(a[i])) end
	return t
end
local Themes = {
	Premium = Pal({12,12,12},{20,20,20},{30,30,30},{58,58,58},{245,245,245},{178,178,178},{120,120,120},{210,210,214}),
	Obsidian = Pal({9,9,12},{14,14,18},{22,22,28},{42,42,52},{238,238,244},{150,150,164},{92,92,106},{150,110,255}),
	Crimson = Pal({11,8,9},{17,12,13},{26,19,21},{52,38,41},{244,238,239},{164,150,152},{106,92,94},{255,82,96}),
	Ocean = Pal({7,11,15},{11,17,23},{17,25,33},{34,48,62},{232,240,246},{140,156,170},{84,100,114},{70,190,255}),
	Mono = Pal({10,10,10},{16,16,16},{24,24,24},{46,46,46},{240,240,240},{154,154,154},{96,96,96},{230,230,230}),
	Custom = Pal({9,9,12},{14,14,18},{22,22,28},{42,42,52},{238,238,244},{150,150,164},{92,92,106},{150,110,255}),
	TierBlack = Pal({6,6,8},{10,10,13},{16,16,20},{36,36,44},{240,240,244},{150,150,160},{90,90,100},{255,255,255}),
	TierWhite = Pal({238,238,242},{228,228,233},{216,216,222},{196,196,204},{18,18,22},{90,90,100},{140,140,150},{20,20,24}),
	TierGray = Pal({24,24,27},{32,32,36},{42,42,47},{64,64,70},{240,240,244},{168,168,176},{110,110,118},{190,190,200}),
	Blood = Pal({14,5,7},{24,8,11},{38,13,18},{70,28,34},{248,238,240},{170,135,142},{104,82,88},{255,72,92}),
	Mint = Pal({5,13,11},{9,23,19},{16,36,30},{34,66,54},{230,255,246},{148,188,172},{88,120,106},{72,240,180}),
	Royal = Pal({8,7,17},{14,11,30},{23,18,48},{46,38,82},{240,236,255},{164,156,192},{98,90,132},{150,120,255}),
	Solar = Pal({15,11,5},{28,20,8},{44,32,12},{78,58,26},{255,247,225},{195,173,128},{125,108,74},{255,190,70}),
	Paper = Pal({242,242,238},{231,231,226},{220,220,214},{188,188,180},{24,24,22},{92,92,86},{132,132,124},{25,25,24}),
	Midnight = Pal({5,7,12},{9,12,20},{16,21,32},{34,42,58},{235,240,250},{148,160,180},{86,98,122},{110,150,255}),
	Arctic = Pal({225,232,240},{214,223,233},{202,213,225},{170,186,205},{18,26,36},{74,88,105},{120,136,154},{65,150,255}),
	Toxic = Pal({7,12,8},{12,20,14},{20,32,22},{42,66,46},{228,255,232},{150,182,156},{90,118,96},{110,255,120}),
	Cyber = Pal({8,6,14},{15,10,28},{25,16,42},{52,32,78},{244,240,255},{170,150,198},{105,86,130},{205,90,255}),
	Terminal = Pal({3,7,4},{6,12,7},{10,22,12},{26,52,31},{210,255,214},{125,180,132},{70,112,78},{70,255,110}),
}
local ThemeNames = {"Obsidian", "Blood", "Mint", "Royal", "Solar", "Paper", "Midnight", "Crimson", "Arctic", "Toxic", "Cyber", "Terminal", "Ocean", "Mono", "Custom", "TierBlack", "TierWhite", "TierGray"}
local AccentNames = {"Theme", "Violet", "Cyan", "Rose", "Emerald", "Amber", "White"}
local AccentColors = {
	Violet = Color3.fromRGB(150,110,255), Cyan = Color3.fromRGB(70,210,255), Rose = Color3.fromRGB(255,96,150),
	Emerald = Color3.fromRGB(70,225,140), Amber = Color3.fromRGB(255,190,70), White = Color3.fromRGB(240,240,240),
}
local SkinThemes = {Sidebar = {"Obsidian", "Theme"}, Floating = {"Crimson", "Theme"}, Taskbar = {"Ocean", "Theme"}, Console = {"Mono", "Emerald"},
	Compact = {"Obsidian", "Cyan"}, Overlay = {"Crimson", "Rose"}, Wheel = {"Ocean", "Theme"}, Custom = {"Custom", "Theme"}}
local MenuSkinNames = {"Sidebar", "Custom"}

local Prefs = {Theme = "Premium", Accent = "Theme", GlassAlpha = 0, AutoText = false}
local Theme, Bound, Refreshers, GlassBound = {}, {}, {}, {}

local TweenNoop = {Play = function() end, Cancel = function() end}
local function Tween(o, props, dur, style, dir)
	if not o or type(props) ~= "table" then return TweenNoop end
	local ok, t = pcall(function()
		return TweenService:Create(o, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	end)
	if not ok or not t then return TweenNoop end
	local played, err = pcall(function() t:Play() end)
	if not played then
		if DebugLog and DebugLog.Push then DebugLog.Push("tween", tostring(err), true) end
		return TweenNoop
	end
	return t
end

local function ApplyGlass()
	for i = #GlassBound, 1, -1 do
		local e = GlassBound[i]
		if e[1].Parent == nil then
			table.remove(GlassBound, i)
		else
			local t = math.clamp(e[2] + Prefs.GlassAlpha * (1 - e[2]), 0, 0.97)
			Tween(e[1], {BackgroundTransparency = t}, 0.25)
		end
	end
end

-- Auto contrast: dark background gets gray text, light background gets dark text.
local function AutoTextFor(bg, soft)
	local lum = 0.2126 * bg.R + 0.7152 * bg.G + 0.0722 * bg.B
	if lum < 0.5 then
		return soft and Color3.fromRGB(128, 128, 136) or Color3.fromRGB(178, 178, 186)
	end
	return soft and Color3.fromRGB(104, 104, 112) or Color3.fromRGB(36, 36, 44)
end

-- Text colour tokens. A user override wins; nil means inherit from the active palette.
local TextKeys = {"TextRow", "TextHeader", "TextValue"}
local TextOverrides = {}
local SaveTextColors = function() end
-- Element colour tokens: override per control type; nil inherits the default below.
local ElemKeys = {"ButtonFill", "ButtonText", "ToggleOn", "SliderFill", "TabActive", "TabText", "TabTextActive", "ToggleKnobOn", "ToggleKnobOff", "SliderKnob"}
local ElemDefault = {ButtonFill = "Accent", ButtonText = "Background", ToggleOn = "Accent", SliderFill = "Accent", TabActive = "Accent", TabText = "SubText", TabTextActive = "Background", ToggleKnobOn = "Background", ToggleKnobOff = "Muted", SliderKnob = "Text"}
local ElemOverrides = {}

local function ApplyTheme()
	for k, v in pairs(Themes[Prefs.Theme]) do Theme[k] = v end
	local ov = AccentColors[Prefs.Accent]
	if ov then Theme.Accent = ov end
	if Prefs.AutoText then
		Theme.Text = AutoTextFor(Theme.Background)
		Theme.SubText = AutoTextFor(Theme.Background, true)
	end
	Theme.TextRow = TextOverrides.TextRow or (Prefs.AutoText and AutoTextFor(Theme.Row)) or Theme.Text
	Theme.TextHeader = TextOverrides.TextHeader or Theme.Accent
	Theme.TextValue = TextOverrides.TextValue or (Prefs.AutoText and AutoTextFor(Theme.Row, true)) or Theme.SubText
	for _, k in ipairs(ElemKeys) do Theme[k] = ElemOverrides[k] or Theme[ElemDefault[k]] end
	-- a near-black on-track (a saved TOGGLE ON colour) falls back to the accent, so the knob stays visible
	if 0.2126 * Theme.ToggleOn.R + 0.7152 * Theme.ToggleOn.G + 0.0722 * Theme.ToggleOn.B < 0.15 then Theme.ToggleOn = Theme.Accent end
	-- button text must stay readable against its fill, even when both were saved close together
	local function LumOf(c) return 0.2126 * c.R + 0.7152 * c.G + 0.0722 * c.B end
	if math.abs(LumOf(Theme.ButtonFill) - LumOf(Theme.ButtonText)) < 0.35 then Theme.ButtonText = AutoTextFor(Theme.ButtonFill) end
	for i = #Bound, 1, -1 do
		local e = Bound[i]
		if e[1].Parent == nil then table.remove(Bound, i) else pcall(Tween, e[1], {[e[2]] = Theme[e[3]]}, 0.3) end
	end
	ApplyGlass()
	for i = #Refreshers, 1, -1 do
		local ok, err = pcall(Refreshers[i])
		if not ok and DebugLog and DebugLog.Push then DebugLog.Push("theme", tostring(err), true) end
	end
end
ApplyTheme()

local function New(class, parent, props)
	local o = Instance.new(class)
	local glassBase = nil
	for p, v in pairs(props or {}) do
		if p == "Glass" then
			glassBase = v
		elseif type(v) == "string" and string.find(p, "Color") and string.sub(v, 1, 1) == "@" then
			local key = string.sub(v, 2)
			table.insert(Bound, {o, p, key})
			o[p] = Theme[key]
		else
			o[p] = v
		end
	end
	if glassBase ~= nil then
		o.BackgroundTransparency = glassBase
		table.insert(GlassBound, {o, glassBase})
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

-- crez_custom v2: the menu engine. ONE builder (CK.Build) produces both the real "Custom" skin and the live
-- preview inside the editor, so the preview is the actual menu code running (tabs, rows, hover, animations, sliders).
local CK = {Cfg = {}, Schema = {}, ByKey = {}, Kits = {}, Cats = {"KITS", "LAYOUT", "BRANDING", "WINDOW", "TABS", "ROWS", "CONTROLS", "MOTION", "MISC", "ADVANCED"}}
do
	local XL, XR, XC = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right, Enum.TextXAlignment.Center
	local function Ch(key, cat, label, opts, def) return {key = key, cat = cat, label = label, kind = "choice", opts = opts, def = def} end
	local function Sl(key, cat, label, min, max, step, def) return {key = key, cat = cat, label = label, kind = "slider", min = min, max = max, step = step, def = def} end
	local function Tx(key, cat, label, max) return {key = key, cat = cat, label = label, kind = "text", max = max, def = ""} end
	CK.Schema = {
		Ch("Nav", "LAYOUT", "Tabs position", {"Left", "Right", "Top", "Bottom"}, "Left"),
		Ch("Header", "LAYOUT", "Header", {"Full", "Slim", "Bare"}, "Full"),
		Ch("TitleAlign", "LAYOUT", "Title align", {"Left", "Center"}, "Left"),
		Sl("Width", "LAYOUT", "Window width", 560, 1000, 10, 760),
		Sl("Height", "LAYOUT", "Window height", 360, 620, 10, 480),
		Sl("Pad", "LAYOUT", "Content padding", 4, 24, 1, 10),
		Ch("Backdrop", "LAYOUT", "Screen backdrop", {"None", "Dim", "Dark"}, "None"),
		Tx("Title", "BRANDING", "Menu title (empty = default)", 22),
		Tx("Subtitle", "BRANDING", "Subtitle (empty = default)", 34),
		Ch("LayoutPreset", "LAYOUT", "LBL_LAYOUT_PRESET", {"Sidebar", "Custom"}, "Sidebar"),
		Ch("HeaderInfo", "BRANDING", "Header info line (Full header)", {"Default", "FPS", "Clock", "Hidden"}, "Default"),
		Ch("Font", "BRANDING", "Font", {"Gotham", "Montserrat", "Ubuntu", "Code", "Jura", "Oswald"}, "Gotham"),
		Ch("TextSize", "BRANDING", "Text size", {"Small", "Normal", "Large"}, "Normal"),
		Sl("Radius", "WINDOW", "Strip corners (bars)", 0, 22, 1, 12),
		Ch("Frame", "WINDOW", "Frame", {"Glow", "Accent", "Line", "None"}, "Glow"),
		Sl("FrameThick", "WINDOW", "Frame thickness", 1, 4, 0.5, 1.5),
		Ch("Gradient", "WINDOW", "Background gradient", {"Off", "Vertical", "Diagonal", "Horizontal"}, "Off"),
		Ch("GradientTint", "WINDOW", "Gradient tint", {"Subtle", "Accent"}, "Subtle"),
		Ch("Strip", "WINDOW", "Accent strip", {"Off", "Header", "Top"}, "Off"),
		Ch("NavStyle", "TABS", "Tab style", {"Bar", "Pill", "Underline", "Block"}, "Bar"),
		Sl("NavWidth", "TABS", "Sidebar width (left/right)", 110, 240, 2, 160),
		Sl("TabH", "TABS", "Tab height", 28, 48, 2, 36),
		Sl("TabRadius", "TABS", "Tab corners", 0, 16, 1, 8),
		Ch("TabIcon", "TABS", "Tab badge", {"None", "Letter", "Number", "Dot"}, "None"),
		Ch("NavLabels", "TABS", "Tab labels", {"Show", "Hide"}, "Show"),
		Ch("RowStyle", "ROWS", "Row style", {"Card", "Flat", "Divider", "Edge"}, "Card"),
		Sl("RowH", "ROWS", "Row height", 32, 52, 2, 40),
		Sl("RowGap", "ROWS", "Row gap", 2, 14, 1, 8),
		Sl("RowRadius", "ROWS", "Row corners", 0, 14, 1, 8),
		Ch("Outline", "ROWS", "Row outline", {"Off", "Soft", "Strong"}, "Soft"),
		Ch("Hover", "ROWS", "Row hover", {"Accent", "None"}, "Accent"),
		Ch("Toggle", "CONTROLS", "Toggle", {"Switch", "Box", "Dot"}, "Switch"),
		Ch("Slider", "CONTROLS", "Slider", {"Thin", "Thick", "Block"}, "Thin"),
		Ch("Button", "CONTROLS", "Buttons", {"Filled", "Outline", "Ghost"}, "Filled"),
		Sl("ButtonRadius", "CONTROLS", "Button corners", 0, 16, 1, 7),
		Ch("Control", "CONTROLS", "Control size", {"Small", "Normal", "Large"}, "Normal"),
		Ch("Section", "CONTROLS", "Section header", {"Bar", "Line", "Plain", "Chip"}, "Bar"),
		Ch("Open", "MOTION", "Open animation", {"Pop", "Fade", "Slide"}, "Pop"),
		Ch("Anim", "MOTION", "Animation speed", {"Fast", "Normal", "Slow"}, "Normal"),
		Sl("Scroll", "MISC", "Scrollbar thickness", 2, 8, 1, 3),
		Ch("ScrollColor", "MISC", "Scrollbar color", {"Accent", "Border", "Muted"}, "Accent"),
	}
	for _, o in ipairs(CK.Schema) do CK.ByKey[o.key] = o end
	function CK.Reset() for _, o in ipairs(CK.Schema) do CK.Cfg[o.key] = o.def end end
	CK.Reset()

	CK.Kits = {
		{name = "Classic", pal = "Obsidian", cfg = {}},
		{name = "Terminal", pal = "Mint", cfg = {Font = "Code", Radius = 2, Frame = "Line", Header = "Slim", NavStyle = "Block", TabRadius = 2, RowRadius = 2, Outline = "Strong",
			Toggle = "Box", Slider = "Block", Button = "Outline", ButtonRadius = 2, Section = "Line", TextSize = "Small", RowH = 34, RowGap = 4, TabH = 30, NavWidth = 140,
			TabIcon = "Number", Title = "TERMINAL", Subtitle = "root@vortex"}},
		{name = "Dock", pal = "Royal", cfg = {Nav = "Bottom", NavStyle = "Pill", TabH = 34, Header = "Slim", TitleAlign = "Center", Radius = 18, RowRadius = 12, Outline = "Off",
			Toggle = "Dot", Slider = "Thick", Section = "Plain", Open = "Slide", Width = 840, Height = 500, TabIcon = "Dot", RowStyle = "Flat"}},
		{name = "Topline", pal = "Blood", cfg = {Nav = "Top", NavStyle = "Underline", Header = "Bare", Radius = 8, RowRadius = 6, Button = "Ghost", Section = "Line", Frame = "Accent",
			TabH = 32, Width = 800, Strip = "Top", RowStyle = "Divider", Outline = "Off"}},
		{name = "Soft", pal = "Solar", cfg = {NavStyle = "Pill", NavWidth = 176, Radius = 20, RowRadius = 14, TabRadius = 14, Outline = "Off", RowH = 44, RowGap = 10, Slider = "Thick",
			Section = "Chip", Font = "Montserrat", Frame = "None", ButtonRadius = 14, Control = "Large"}},
		{name = "Mirror", pal = "Paper", cfg = {Nav = "Right", NavStyle = "Underline", Radius = 6, RowRadius = 4, Outline = "Strong", Toggle = "Box", Frame = "Line", RowStyle = "Edge"}},
		{name = "Glass", pal = "Royal", glass = 0.4, cfg = {Radius = 16, Frame = "Accent", Gradient = "Diagonal", GradientTint = "Accent", Outline = "Off", RowStyle = "Flat", NavStyle = "Pill",
			TabIcon = "Letter", Backdrop = "Dim", Open = "Fade"}},
		{name = "Neon", pal = "Mint", cfg = {Radius = 4, Frame = "Glow", FrameThick = 2, Strip = "Header", Gradient = "Vertical", Toggle = "Dot", Slider = "Block", Section = "Chip",
			TabIcon = "Letter", NavStyle = "Block", Font = "Jura", HeaderInfo = "FPS", Anim = "Fast"}},
		{name = "Icons", pal = "Obsidian", cfg = {NavLabels = "Hide", TabIcon = "Letter", NavStyle = "Pill", TabH = 40, Header = "Slim", Section = "Chip", RowStyle = "Edge", Radius = 14}},
		{name = "Compact", pal = "Obsidian", cfg = {Width = 640, Height = 420, Header = "Bare", RowH = 32, RowGap = 4, TabH = 28, NavWidth = 130, TextSize = "Small", Control = "Small",
			Pad = 6, Radius = 8, RowRadius = 5}},
	}

	local FontSets = {Gotham = {"GothamMedium", "GothamBold"}, Montserrat = {"MontserratMedium", "MontserratBold"}, Ubuntu = {"Ubuntu", "Ubuntu"},
		Code = {"Code", "Code"}, Jura = {"Jura", "Jura"}, Oswald = {"Oswald", "Oswald"}}
	local function GetFont(n, fallback)
		local ok, v = pcall(function() return Enum.Font[n] end)
		if ok and v then return v end
		return fallback
	end
	function CK.Fonts(cfg)
		local s = FontSets[cfg.Font] or FontSets.Gotham
		return GetFont(s[1], Enum.Font.GothamMedium), GetFont(s[2], Enum.Font.GothamBold)
	end

	function CK.Ctx(cfg, connect, label, snap, extra)
		local FM, FB = CK.Fonts(cfg)
		local x = {c = cfg, connect = connect, label = label, snap = snap == true, FM = FM, FB = FB,
			d = cfg.TextSize == "Small" and -1 or (cfg.TextSize == "Large" and 1 or 0),
			f = cfg.Control == "Small" and 0.85 or (cfg.Control == "Large" and 1.2 or 1),
			speed = cfg.Anim == "Fast" and 0.55 or (cfg.Anim == "Slow" and 1.7 or 1)}
		if extra then for k, v in pairs(extra) do x[k] = v end end
		return x
	end
	local function Z(x, n) return math.floor(n * x.f + 0.5) end
	local function Tw(x, o, props, dur)
		if x.snap then for k, v in pairs(props) do o[k] = v end else Tween(o, props, (dur or 0.2) * x.speed) end
	end
	local function Tag(x, inst, cat, pr) if x.tag then x.tag(inst, cat, pr) end end
	local function Mix(a, b, t) return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t) end
	local function HexColor(hex, fallback)
		if type(hex) ~= "string" then return fallback end
		local h = string.match(hex, "^#?(%x%x%x%x%x%x)$")
		if not h then return fallback end
		return Color3.fromRGB(tonumber(string.sub(h,1,2),16), tonumber(string.sub(h,3,4),16), tonumber(string.sub(h,5,6),16))
	end

	local FX_EASING = {
		Linear = Enum.EasingStyle.Linear, Quad = Enum.EasingStyle.Quad, Cubic = Enum.EasingStyle.Cubic,
		Quart = Enum.EasingStyle.Quart, Quint = Enum.EasingStyle.Quint, Sine = Enum.EasingStyle.Sine,
		Back = Enum.EasingStyle.Back, Bounce = Enum.EasingStyle.Bounce, Elastic = Enum.EasingStyle.Elastic,
		Circular = Enum.EasingStyle.Circular,
	}
	local FX_DIR = {In = Enum.EasingDirection.In, Out = Enum.EasingDirection.Out, InOut = Enum.EasingDirection.InOut}
	local function FxList(v)
		if type(v) == "table" then return v end
		if type(v) ~= "string" or v == "" or v == "None" then return {} end
		local out = {}
		for s in string.gmatch(v, "[^,%+>]+") do
			s = string.gsub(s, "^%s+", ""); s = string.gsub(s, "%s+$", "")
			if s ~= "" and s ~= "None" then table.insert(out, s) end
		end
		return out
	end
	local function FxMerge(listA, listB)
		local out = {}
		for _, v in ipairs(FxList(listA)) do out[#out+1] = v end
		for _, v in ipairs(FxList(listB)) do out[#out+1] = v end
		return out
	end
	local function FxColor(hex, fallback) return HexColor(hex, fallback) end
	local function FxDuration(opt, all)
		local d = tonumber((type(opt) == "table" and opt.duration) or (all and all.Duration)) or 0.18
		local speed = tonumber((type(opt) == "table" and opt.speed) or (all and all.Speed)) or 1
		return math.clamp(d / math.max(speed, 0.05), 0.03, 3)
	end
	local function FxTween(obj, props, dur, easing, direction)
		if not obj or not obj.Parent then return end
		local style = FX_EASING[easing or "Quad"] or Enum.EasingStyle.Quad
		local dir = FX_DIR[direction or "Out"] or Enum.EasingDirection.Out
		pcall(function() Tween(obj, props, dur, style, dir) end)
	end
	local function FxSound(parent, id, volume, pitch)
		if type(id) ~= "string" or id == "" then return end
		local ok, snd = pcall(function()
				return New("Sound", parent, {SoundId = id, Volume = math.clamp(tonumber(volume) or 0.55, 0, 1), PlaybackSpeed = tonumber(pitch) or 1})
			end)
		if ok and snd then
			pcall(function() snd:Play() end)
			task.delay(4, function() if snd.Parent then snd:Destroy() end end)
		end
	end
	local function FxScale(inst, name)
		if not inst then return nil end
		return inst:FindFirstChild(name) or New("UIScale", inst, {Name = name, Scale = 1})
	end
	local function FxStroke(inst, color)
		local s = inst:FindFirstChild("__CustomFxStroke")
		if not s then s = New("UIStroke", inst, {Name = "__CustomFxStroke", Color = color, Thickness = 1, Transparency = 1}) end
		return s
	end
	local function FxPoint(node, input)
		if input and input.Position then return Vector2.new(input.Position.X - node.AbsolutePosition.X, input.Position.Y - node.AbsolutePosition.Y) end
		return node.AbsoluteSize * 0.5
	end
	local function FxBurst(node, color, second, mode, dur, sizeMul, point)
		if not node or not node.Parent then return end
		local parent = node
		local center = point or (node.AbsoluteSize * 0.5)
		if mode == "Ring" then
			local ring = New("Frame", parent, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(center.X, center.Y), Size = UDim2.fromOffset(8,8), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = (node.ZIndex or 1) + 5})
			Round(ring, 100); local st = New("UIStroke", ring, {Color = color, Thickness = 2, Transparency = 0})
			FxTween(ring, {Size = UDim2.fromOffset(70 * sizeMul,70 * sizeMul), BackgroundTransparency = 1}, dur, "Quart", "Out")
			FxTween(st, {Transparency = 1}, dur, "Quad", "Out")
			task.delay(dur + 0.05, function() if ring.Parent then ring:Destroy() end end)
		elseif mode == "Particles" then
			for i = 1, 12 do
				local f = Round(New("Frame", parent, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(center.X, center.Y), Size = UDim2.fromOffset(math.random(3,7), math.random(3,7)), BackgroundColor3 = i % 2 == 0 and second or color, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = (node.ZIndex or 1) + 5}), 100)
				local a = math.rad((i-1) * 30 + math.random(-12,12)); local dst = 38 * sizeMul + math.random(-8,12)
				FxTween(f, {Position = UDim2.fromOffset(center.X + math.cos(a)*dst, center.Y + math.sin(a)*dst), BackgroundTransparency = 1, Size = UDim2.fromOffset(1,1)}, dur, "Quad", "Out")
				task.delay(dur + 0.05, function() if f.Parent then f:Destroy() end end)
			end
		elseif mode == "Confetti" then
			for i = 1, 16 do
				local f = New("Frame", parent, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(center.X, center.Y), Size = UDim2.fromOffset(4,8), BackgroundColor3 = i % 2 == 0 and second or color, BorderSizePixel = 0, Rotation = math.random(-25,25), ZIndex = (node.ZIndex or 1) + 5})
				local a = math.rad(math.random(240,300)); local dst = math.random(35,75) * sizeMul
				FxTween(f, {Position = UDim2.fromOffset(center.X + math.cos(a)*dst, center.Y + math.sin(a)*dst + 24), Rotation = f.Rotation + math.random(-180,180), BackgroundTransparency = 1}, dur * 1.15, "Quad", "Out")
				task.delay(dur * 1.2, function() if f.Parent then f:Destroy() end end)
			end
		end
	end
	function CK.PlayEffect(target, effect, opt)
		if not target or not target.Parent or not effect or effect == "None" then return end
		opt = type(opt) == "table" and opt or {}
		local all = CK.Custom and CK.Custom.Effects or {}
		local color = FxColor(opt.color or all.Color, Theme.Accent)
		local color2 = FxColor(opt.color2 or all.Color2, Theme.Text)
		local dur = FxDuration(opt, all)
		local mul = tonumber(opt.size or opt.intensity) or 1
		local sc, stroke
		if effect == "Ripple" or effect == "RippleSoft" then
			local p = opt.point or target.AbsoluteSize * 0.5
			local radius = math.max(target.AbsoluteSize.X, target.AbsoluteSize.Y) * (1.2 + (effect == "RippleSoft" and 0.5 or 0)) * mul
			local f = Round(New("Frame", target, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromOffset(p.X,p.Y), Size = UDim2.fromOffset(1,1), BackgroundColor3 = color, BackgroundTransparency = effect == "RippleSoft" and 0.55 or 0.35, BorderSizePixel = 0, ZIndex = (target.ZIndex or 1) + 4}), 100)
			FxTween(f, {Size = UDim2.fromOffset(radius,radius), BackgroundTransparency = 1}, dur, "Quart", "Out")
			task.delay(dur + 0.04, function() if f.Parent then f:Destroy() end end)
		elseif effect == "Pulse" or effect == "Press" or effect == "Compress" or effect == "Shrink" then
			sc = FxScale(target, "__CustomFxScale"); local amount = effect == "Pulse" and 0.96 or 0.94
			FxTween(sc, {Scale = amount}, dur * 0.35, "Quad", "Out")
			task.delay(dur * 0.35, function() if sc.Parent then FxTween(sc, {Scale = 1}, dur * 0.65, "Back", "Out") end end)
		elseif effect == "Bounce" or effect == "Pop" or effect == "Overshoot" or effect == "Elastic" then
			sc = FxScale(target, "__CustomFxScale"); local start = effect == "Pop" and 0.86 or 0.94; sc.Scale = start
			FxTween(sc, {Scale = 1}, dur, effect == "Elastic" and "Elastic" or "Back", "Out")
		elseif effect == "Glow" or effect == "GlowPulse" or effect == "BorderPulse" or effect == "Neon" then
			stroke = FxStroke(target, color); stroke.Color = color
			FxTween(stroke, {Transparency = effect == "GlowPulse" and 0.05 or 0.15, Thickness = effect == "Neon" and 2.4 or 1.8}, dur * 0.45, "Sine", "Out")
			if effect == "GlowPulse" or effect == "BorderPulse" then task.delay(dur * 0.45, function() if stroke.Parent then FxTween(stroke, {Transparency = 0.8, Thickness = 1}, dur * 0.55, "Sine", "InOut") end end) end
		elseif effect == "Flash" or effect == "FlashWhite" then
			local f = New("Frame", target, {Size = UDim2.fromScale(1,1), BackgroundColor3 = effect == "FlashWhite" and Color3.new(1,1,1) or color, BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = (target.ZIndex or 1) + 3})
			Round(f, 100); FxTween(f, {BackgroundTransparency = 1}, dur, "Quad", "Out")
			task.delay(dur + 0.03, function() if f.Parent then f:Destroy() end end)
		elseif effect == "Lift" or effect == "HoverUp" then
			sc = FxScale(target, "__CustomFxHoverScale"); FxTween(sc, {Scale = 1.025}, dur, "Quad", "Out")
		elseif effect == "Reset" or effect == "FadeToNormal" then
			sc = target:FindFirstChild("__CustomFxScale") or target:FindFirstChild("__CustomFxHoverScale"); if sc then FxTween(sc, {Scale = 1}, dur, "Quad", "Out") end
			stroke = target:FindFirstChild("__CustomFxStroke"); if stroke then FxTween(stroke, {Transparency = 1, Thickness = 1}, dur, "Quad", "Out") end
		elseif effect == "Shake" or effect == "ShakeSoft" or effect == "ShakeHard" then
			local base = target.Position; local amp = effect == "ShakeHard" and 7 or (effect == "ShakeSoft" and 2 or 4)
			task.spawn(function()
				local steps = math.max(4, math.floor(dur / 0.025)); for i = 1, steps do
					if not target.Parent then return end; local a = (i/steps)*math.pi*4; local k = (1-i/steps)*amp
					target.Position = base + UDim2.fromOffset(math.sin(a)*k, math.cos(a*1.17)*k*0.55); task.wait(dur/steps)
				end
				if target.Parent then target.Position = base end
			end)
		elseif effect == "Tilt" or effect == "Rotate" or effect == "Wobble" then
			local base = target.Rotation; local angle = effect == "Wobble" and 6 or 3
			FxTween(target, {Rotation = base + angle}, dur * 0.45, "Sine", "Out")
			task.delay(dur * 0.45, function() if target.Parent then FxTween(target, {Rotation = base - angle}, dur * 0.35, "Sine", "InOut") end end)
			task.delay(dur * 0.8, function() if target.Parent then FxTween(target, {Rotation = base}, dur * 0.2, "Sine", "Out") end end)
		elseif effect == "Spin" or effect == "SpinFast" then
			local base = target.Rotation; local turns = effect == "SpinFast" and 360 or 180; FxTween(target, {Rotation = base + turns}, dur, "Quad", "Out")
			task.delay(dur + 0.01, function() if target.Parent then target.Rotation = base end end)
		elseif effect == "Expand" or effect == "Grow" then
			sc = FxScale(target, "__CustomFxScale"); sc.Scale = 0.92; FxTween(sc, {Scale = 1}, dur, "Back", "Out")
		elseif effect == "Jelly" then
			sc = FxScale(target, "__CustomFxScale"); FxTween(sc, {Scale = 1.06}, dur*0.25, "Sine", "Out"); task.delay(dur*0.25, function() if sc.Parent then FxTween(sc, {Scale = 0.97}, dur*0.25, "Back", "Out") end end); task.delay(dur*0.5, function() if sc.Parent then FxTween(sc, {Scale = 1}, dur*0.5, "Back", "Out") end end)
	elseif effect == "Shine" or effect == "Sweep" or effect == "Glint" then
		local f = New("Frame", target, {Size = UDim2.new(0, math.max(24, target.AbsoluteSize.X*0.2), 1, 0), Position = UDim2.new(0,-40,0,0), BackgroundColor3 = color2, BackgroundTransparency = 0.55, BorderSizePixel = 0, Rotation = effect == "Glint" and 12 or 0, ZIndex = (target.ZIndex or 1)+2})
		New("UIGradient", f, {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.5,0.15), NumberSequenceKeypoint.new(1,1)})})
		FxTween(f, {Position = UDim2.new(1,20,0,0)}, dur, "Sine", "InOut")
		task.delay(dur+0.04, function() if f.Parent then f:Destroy() end end)
	elseif effect == "ColorPulse" or effect == "Rainbow" then
		stroke = FxStroke(target, color); local old = stroke.Color
		FxTween(stroke, {Color = color2, Transparency = 0.1, Thickness = 2}, dur*0.5, "Sine", "InOut")
		task.delay(dur*0.5, function() if stroke.Parent then FxTween(stroke, {Color = old, Transparency = 1, Thickness = 1}, dur*0.5, "Sine", "InOut") end end)
	elseif effect == "RingBurst" then
		FxBurst(target, color, color2, "Ring", dur, mul, opt.point)
	elseif effect == "ParticleBurst" or effect == "Spark" or effect == "DotBurst" then
		FxBurst(target, color, color2, "Particles", dur, mul, opt.point)
	elseif effect == "Confetti" then
		FxBurst(target, color, color2, "Confetti", dur, mul, opt.point)
	elseif effect == "SlideLeft" or effect == "SlideRight" or effect == "SlideUp" or effect == "SlideDown" then
		local base = target.Position; local dx,dy = 18,0; if effect == "SlideLeft" then dx=-18 elseif effect == "SlideUp" then dx,dy=0,-18 elseif effect == "SlideDown" then dx,dy=0,18 end
		target.Position = base + UDim2.fromOffset(dx,dy); FxTween(target, {Position = base}, dur, "Quart", "Out")
	elseif effect == "Echo" then
		local stroke2 = New("UIStroke", target, {Name = "__CustomFxEcho", Color = color, Thickness = 1, Transparency = 0.45}); FxTween(stroke2, {Thickness = 10, Transparency = 1}, dur, "Quad", "Out"); task.delay(dur+0.03,function() if stroke2.Parent then stroke2:Destroy() end end)
	elseif effect == "Flicker" or effect == "FlickerSoft" then
		task.spawn(function()
			local count = effect == "FlickerSoft" and 4 or 6
			for i=1,count do
				if not target.Parent then return end
				target.Visible = i%2==1
				task.wait(dur/(count+1))
			end
			if target.Parent then target.Visible=true end
		end)
	elseif effect == "Shrink" then
		sc=FxScale(target,"__CustomFxScale")
		sc.Scale=1.06
		FxTween(sc,{Scale=1},dur,"Back","Out")
	elseif effect == "PulseSoft" or effect == "PulseHard" then
		sc=FxScale(target,"__CustomFxScale")
		local amt=effect=="PulseHard" and 0.90 or 0.97
		FxTween(sc,{Scale=amt},dur*0.34,"Sine","Out")
		task.delay(dur*0.34,function() if sc.Parent then FxTween(sc,{Scale=1.035},dur*0.26,"Back","Out") end end)
		task.delay(dur*0.60,function() if sc.Parent then FxTween(sc,{Scale=1},dur*0.40,"Sine","Out") end end)
	elseif effect == "Squash" or effect == "Stretch" then
		sc=FxScale(target,"__CustomFxScale")
		local start=effect=="Squash" and 0.96 or 0.985
		local peak=effect=="Squash" and 1.02 or 1.035
		sc.Scale=start
		FxTween(sc,{Scale=peak},dur*0.45,"Sine","Out")
		task.delay(dur*0.45,function() if sc.Parent then FxTween(sc,{Scale=1},dur*0.55,"Back","Out") end end)
	elseif effect == "Spring" or effect == "Snappy" then
		sc=FxScale(target,"__CustomFxScale")
		sc.Scale=effect=="Snappy" and 0.92 or 0.95
		FxTween(sc,{Scale=1},dur,effect=="Snappy" and "Back" or "Elastic","Out")
	elseif effect == "Float" or effect == "FloatSoft" then
		local base=target.Position; local amount=effect=="FloatSoft" and 3 or 6
		target.Position=base+UDim2.fromOffset(0,amount)
		FxTween(target,{Position=base},dur,"Sine","Out")
	elseif effect == "HoverDown" then
		local base=target.Position
		FxTween(target,{Position=base+UDim2.fromOffset(0,3)},dur,"Sine","Out")
	elseif effect == "Magnetic" then
		sc=FxScale(target,"__CustomFxMagnetScale"); FxTween(sc,{Scale=1.035},dur,"Quad","Out")
		stroke=FxStroke(target,color); FxTween(stroke,{Transparency=0.15,Thickness=1.8},dur,"Sine","Out")
	elseif effect == "Heartbeat" then
		sc=FxScale(target,"__CustomFxScale")
		FxTween(sc,{Scale=1.035},dur*0.2,"Sine","Out")
		task.delay(dur*0.2,function() if sc.Parent then FxTween(sc,{Scale=0.985},dur*0.18,"Sine","InOut") end end)
		task.delay(dur*0.38,function() if sc.Parent then FxTween(sc,{Scale=1.02},dur*0.20,"Sine","Out") end end)
		task.delay(dur*0.58,function() if sc.Parent then FxTween(sc,{Scale=1},dur*0.42,"Sine","Out") end end)
	elseif effect == "Breath" then
		sc=FxScale(target,"__CustomFxScale")
		FxTween(sc,{Scale=1.02},dur*0.5,"Sine","InOut")
		task.delay(dur*0.5,function() if sc.Parent then FxTween(sc,{Scale=1},dur*0.5,"Sine","InOut") end end)
	elseif effect == "Jitter" then
		local base=target.Position
		task.spawn(function()
			local steps=math.max(5,math.floor(dur/0.018))
			for i=1,steps do
				if not target.Parent then return end
				local d=1-i/steps
				target.Position=base+UDim2.fromOffset(math.random(-4,4)*d,math.random(-3,3)*d)
				task.wait(dur/steps)
			end
			if target.Parent then target.Position=base end
		end)
	elseif effect == "TiltLeft" or effect == "TiltRight" then
		local base=target.Rotation; local angle=effect=="TiltLeft" and -5 or 5
		FxTween(target,{Rotation=base+angle},dur*0.4,"Sine","Out")
		task.delay(dur*0.4,function() if target.Parent then FxTween(target,{Rotation=base},dur*0.6,"Back","Out") end end)
	elseif effect == "SpinReverse" then
		local base=target.Rotation
		FxTween(target,{Rotation=base-180},dur,"Quad","Out")
		task.delay(dur+0.01,function() if target.Parent then target.Rotation=base end end)
	elseif effect == "Orbit" then
		local dot=Round(New("Frame",target,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(8*mul,8*mul),BackgroundColor3=color,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)+7}),100)
		task.spawn(function()
			local steps=math.max(12,math.floor(dur/0.02))
			for i=1,steps do
				if not dot.Parent then return end
				local a=(i/steps)*math.pi*2
				local radius=math.max(12,math.min(target.AbsoluteSize.X,target.AbsoluteSize.Y)*0.42)*mul
				dot.Position=UDim2.fromOffset(target.AbsoluteSize.X*0.5+math.cos(a)*radius,target.AbsoluteSize.Y*0.5+math.sin(a)*radius)
				dot.BackgroundTransparency=i/steps
				task.wait(dur/steps)
			end
			if dot.Parent then dot:Destroy() end
		end)
	elseif effect == "HaloRing" or effect == "RippleWide" then
		local p=opt.point or target.AbsoluteSize*0.5
		local radius=math.max(target.AbsoluteSize.X,target.AbsoluteSize.Y)*(1.35+(effect=="RippleWide" and 0.55 or 0))*mul
		local f=Round(New("Frame",target,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(p.X,p.Y),Size=UDim2.fromOffset(8,8),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)+5}),100)
		local st=New("UIStroke",f,{Color=color,Thickness=effect=="HaloRing" and 2.5 or 2,Transparency=0.1})
		FxTween(f,{Size=UDim2.fromOffset(radius,radius)},dur,"Quart","Out")
		FxTween(st,{Transparency=1,Thickness=0.5},dur,"Quad","Out")
		task.delay(dur+0.05,function() if f.Parent then f:Destroy() end end)
	elseif effect == "RippleDouble" then
		local p=opt.point or target.AbsoluteSize*0.5
		for idx=1,2 do
			task.delay((idx-1)*dur*0.18,function()
				if not target.Parent then return end
				local f=Round(New("Frame",target,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(p.X,p.Y),Size=UDim2.fromOffset(1,1),BackgroundColor3=idx==1 and color or color2,BackgroundTransparency=0.45,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)+4}),100)
				local r=math.max(target.AbsoluteSize.X,target.AbsoluteSize.Y)*1.5*mul
				FxTween(f,{Size=UDim2.fromOffset(r,r),BackgroundTransparency=1},dur,"Quart","Out")
				task.delay(dur+0.04,function() if f.Parent then f:Destroy() end end)
			end)
		end
	elseif effect == "StarBurst" or effect == "CornerPulse" or effect == "CornerFlash" then
		local center=opt.point or target.AbsoluteSize*0.5; local count=effect=="StarBurst" and 10 or 4
		for i=1,count do
			local a=math.rad((i-1)*(360/count)); local len=effect=="StarBurst" and 30 or 12
			local ray=New("Frame",target,{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromOffset(center.X,center.Y),Size=UDim2.fromOffset(2,effect=="StarBurst" and 2 or 3),Rotation=math.deg(a),BackgroundColor3=i%2==0 and color2 or color,BackgroundTransparency=effect=="CornerFlash" and 0 or 0.05,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)+5})
			FxTween(ray,{Size=UDim2.fromOffset(len*mul,ray.Size.Y.Offset),BackgroundTransparency=1},effect=="CornerFlash" and dur*0.75 or dur,"Quart","Out")
			task.delay(dur+0.04,function() if ray.Parent then ray:Destroy() end end)
		end
	elseif effect == "Scanline" or effect == "Spotlight" or effect == "Meteor" then
		local w=effect=="Meteor" and 12 or math.max(24,target.AbsoluteSize.X*0.22)
		local h=effect=="Meteor" and 3 or target.AbsoluteSize.Y
		local y=effect=="Meteor" and target.AbsoluteSize.Y*0.5 or 0
		local f=New("Frame",target,{Size=UDim2.fromOffset(w,h),Position=UDim2.fromOffset(-w,y),BackgroundColor3=color2,BackgroundTransparency=effect=="Spotlight" and 0.6 or 0.35,BorderSizePixel=0,Rotation=effect=="Meteor" and -14 or 0,ZIndex=(target.ZIndex or 1)+3})
		New("UIGradient",f,{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.15),NumberSequenceKeypoint.new(1,1)})})
		FxTween(f,{Position=UDim2.new(1,w,0,y)},dur,"Sine","InOut")
		task.delay(dur+0.04,function() if f.Parent then f:Destroy() end end)
	elseif effect == "Aura" or effect == "UnderGlow" then
		stroke=FxStroke(target,color)
		FxTween(stroke,{Transparency=0.12,Thickness=effect=="Aura" and 2.6 or 1.6,Color=color},dur*0.5,"Sine","Out")
		task.delay(dur*0.5,function() if stroke.Parent then FxTween(stroke,{Transparency=0.72,Thickness=1},dur*0.5,"Sine","InOut") end end)
	elseif effect == "Ghost" or effect == "AfterImage" then
		local ghost=New("Frame",target,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)-1})
		local gs=New("UIStroke",ghost,{Color=color2,Thickness=2,Transparency=0.25})
		FxTween(gs,{Transparency=1,Thickness=6},dur,"Quad","Out")
		task.delay(dur+0.04,function() if ghost.Parent then ghost:Destroy() end end)
	elseif effect == "Glitch" or effect == "Chromatic" then
		local ga=New("Frame",target,{Size=UDim2.fromScale(1,1),Position=UDim2.fromOffset(-2,0),BackgroundColor3=color,BackgroundTransparency=0.82,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)-1})
		local gb=New("Frame",target,{Size=UDim2.fromScale(1,1),Position=UDim2.fromOffset(2,0),BackgroundColor3=color2,BackgroundTransparency=0.82,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)-1})
		FxTween(ga,{BackgroundTransparency=1,Position=UDim2.fromOffset(3,math.random(-2,2))},dur*0.55,"Quad","Out")
		FxTween(gb,{BackgroundTransparency=1,Position=UDim2.fromOffset(-3,math.random(-2,2))},dur*0.55,"Quad","Out")
		task.delay(dur*0.6,function() if ga.Parent then ga:Destroy() end; if gb.Parent then gb:Destroy() end end)
	elseif effect == "ParticleRain" then
		for i=1,14 do
			local f=Round(New("Frame",target,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(math.random(0,math.max(1,target.AbsoluteSize.X)), -math.random(4,24)),Size=UDim2.fromOffset(math.random(2,5),math.random(2,5)),BackgroundColor3=i%2==0 and color2 or color,BackgroundTransparency=0.05,BorderSizePixel=0,ZIndex=(target.ZIndex or 1)+5}),100)
			local fall=math.random(22,math.max(28,target.AbsoluteSize.Y+35))
			FxTween(f,{Position=UDim2.fromOffset(f.Position.X.Offset,fall),BackgroundTransparency=1,Rotation=math.random(-160,160)},dur,"Quad","Out")
			task.delay(dur+0.04,function() if f.Parent then f:Destroy() end end)
		end
	elseif effect == "HueSweep" or effect == "Rainbow" then
		stroke=FxStroke(target,color)
		local token=tostring(os.clock()) .. tostring(math.random())
		stroke:SetAttribute("__HueSweepToken",token)
		task.spawn(function()
			local steps=math.max(8,math.floor(dur/0.035))
			for i=1,steps do
				if not stroke.Parent or stroke:GetAttribute("__HueSweepToken")~=token then return end
				local hue=(i-1)/steps
				stroke.Color=Color3.fromHSV(hue,0.78,1)
				stroke.Transparency=0.08
				stroke.Thickness=2
				task.wait(dur/steps)
			end
			if stroke.Parent and stroke:GetAttribute("__HueSweepToken")==token then
				stroke.Color=color
				stroke.Transparency=1
				stroke.Thickness=1
			end
		end)
	elseif effect == "DriftLeft" or effect == "DriftRight" then
		local base=target.Position; local dx=effect=="DriftLeft" and -10 or 10
		target.Position=base+UDim2.fromOffset(dx,0)
		FxTween(target,{Position=base},dur,"Sine","Out")
	elseif effect == "FadeIn" then
		if target:IsA("CanvasGroup") then target.GroupTransparency = 1; FxTween(target, {GroupTransparency = 0}, dur, "Sine", "Out") end
	elseif effect == "FadeOut" then
		if target:IsA("CanvasGroup") then FxTween(target, {GroupTransparency = 1}, dur, "Sine", "Out") end
	elseif effect == "FadeOutIn" then
		if target:IsA("CanvasGroup") then FxTween(target, {GroupTransparency = 1}, dur * 0.45, "Sine", "Out"); task.delay(dur * 0.45, function() if target.Parent then FxTween(target, {GroupTransparency = 0}, dur * 0.55, "Sine", "In") end end) end
	elseif effect == "Dim" then
		if target:IsA("CanvasGroup") then FxTween(target, {GroupTransparency = 0.35}, dur, "Sine", "Out") end
	end
	local sound = opt.sound
	if sound and sound ~= "" then FxSound(target, sound, opt.volume or all.Volume, opt.pitch or 1) end
end
	function CK.PlayEffects(target, list, opt)
		local cfg=CK.Custom and CK.Custom.Effects or {}
		local items=FxList(list); local stagger=tonumber((type(opt)=="table" and opt.stagger) or cfg.Stagger) or 0
		for i,fx in ipairs(items) do
			local localOpt={}
			if type(opt)=="table" then for k,v in pairs(opt) do localOpt[k]=v end end
			if cfg.ReduceMotion then localOpt.speed=math.max(tonumber(localOpt.speed) or tonumber(cfg.Speed) or 1,1.35); localOpt.size=math.min(tonumber(localOpt.size) or 1,0.82) end
			if stagger>0 and i>1 then task.delay((i-1)*stagger,function() CK.PlayEffect(target,fx,localOpt) end) else CK.PlayEffect(target,fx,localOpt) end
		end
	end
	function CK.BindEffects(x, button, opt)
		if not button or not button:IsA("GuiButton") then return end
		local all = CK.Custom and CK.Custom.Effects or {}
		opt = type(opt) == "table" and opt or {}
		local ev = type(opt.events) == "table" and opt.events or {}
		local function eventCfg(name, fallback, soundKey)
			local e = ev[name]
			if e == false then return {effects = {}} end
			if e == nil then e = {} end
			local effects = e.effects or e.fx or (name == "click" and opt.fx) or fallback
			return {effects = effects, duration = e.duration or opt.duration, color = e.color or opt.color, color2 = e.color2 or opt.color2,
				speed = e.speed or opt.speed, size = e.size or opt.size, easing = e.easing or opt.easing, direction = e.direction or opt.direction,
				sound = e.sound or (soundKey and all[soundKey]) or nil, volume = e.volume or all.Volume, pitch = e.pitch}
		end
		local hoverIn = eventCfg("hoverEnter", all.Hover, "HoverSound")
		local hoverOut = eventCfg("hoverLeave", {"FadeToNormal"}, nil)
		local press = eventCfg("press", all.Press, "PressSound")
		local release = eventCfg("release", all.Release, "ReleaseSound")
		local click = eventCfg("click", all.Click, "ClickSound")
		local rightClick = eventCfg("rightClick", all.RightClick, nil)
		x.connect(button.MouseEnter, function()
			CK.PlayEffects(button, hoverIn.effects, hoverIn)
			if tonumber(all.HoverScale) then
				local hs=FxScale(button,"__CustomFxHoverScale")
				FxTween(hs,{Scale=tonumber(all.HoverScale)},hoverIn.duration or all.Duration,"Quad","Out")
			end
			if tonumber(all.HoverRotation) and tonumber(all.HoverRotation)~=0 then
				FxTween(button,{Rotation=tonumber(all.HoverRotation)},hoverIn.duration or all.Duration,"Sine","Out")
			end
		end)
		x.connect(button.MouseLeave, function()
			CK.PlayEffects(button, hoverOut.effects, hoverOut)
			local hs=button:FindFirstChild("__CustomFxHoverScale"); if hs then FxTween(hs,{Scale=1},hoverOut.duration or all.Duration,"Quad","Out") end
			FxTween(button,{Rotation=0},hoverOut.duration or all.Duration,"Sine","Out")
		end)
		x.connect(button.MouseButton1Down, function(input)
			press.point=FxPoint(button,input); CK.PlayEffects(button,press.effects,press)
			if tonumber(all.PressScale) then
				local ps=FxScale(button,"__CustomFxScale"); FxTween(ps,{Scale=tonumber(all.PressScale)},(press.duration or all.Duration)*0.35,"Quad","Out")
			end
		end)
		x.connect(button.MouseButton1Up, function()
			CK.PlayEffects(button,release.effects,release)
			local ps=button:FindFirstChild("__CustomFxScale"); if ps then FxTween(ps,{Scale=1},release.duration or all.Duration,"Back","Out") end
		end)
		x.connect(button.MouseButton1Click, function(input) click.point=FxPoint(button,input); CK.PlayEffects(button,click.effects,click) end)
		x.connect(button.MouseButton2Click, function(input) rightClick.point=FxPoint(button,input); CK.PlayEffects(button,rightClick.effects,rightClick) end)
	end

	function CK.SyncTheme() for k, v in pairs(Themes.Custom) do Theme[k] = v end end
	function CK.GlassSnap()
		for i = #GlassBound, 1, -1 do
			local e = GlassBound[i]
			if e[1].Parent == nil then table.remove(GlassBound, i)
			else e[1].BackgroundTransparency = math.clamp(e[2] + Prefs.GlassAlpha * (1 - e[2]), 0, 0.97) end
		end
	end

	-- returns a tween that must be :Cancel()ed on destroy (or nil)
	function CK.Frame(x, root, refreshers)
		local f, th = x.c.Frame, x.c.FrameThick
		if f == "Glow" then
			local s = New("UIStroke", root, {Thickness = th, Color = Color3.new(1,1,1), ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
			local g = New("UIGradient", s, {})
			local function Paint()
				g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(0.5, Theme.Border), ColorSequenceKeypoint.new(1, Theme.Accent)})
			end
			Paint(); table.insert(refreshers, Paint)
			local spin = TweenService:Create(g, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Rotation = 360})
			spin:Play()
			return spin
		elseif f == "Accent" then
			New("UIStroke", root, {Color = "@Accent", Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
		elseif f == "Line" then
			New("UIStroke", root, {Color = "@Border", Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
		end
		return nil
	end

	function CK.Row(x, parent, h, click, order, fxOpt)
		local c = x.c
		local style = c.RowStyle
		local props = {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", BorderSizePixel = 0, LayoutOrder = order}
		if style == "Card" or style == "Edge" then props.Glass = 0 else props.BackgroundTransparency = 1 end
		local r = New(click and "TextButton" or "Frame", parent, props)
		if click then r.Text = ""; r.AutoButtonColor = false end
		Round(r, c.RowRadius)
		local t0 = c.Outline == "Off" and 1 or (c.Outline == "Soft" and 0.3 or 0)
		local s = New("UIStroke", r, {Color = "@Border", Thickness = 1, Transparency = t0})
		if style == "Divider" then
			New("Frame", r, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,0,1,0), Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
		elseif style == "Edge" then
			Round(New("Frame", r, {Position = UDim2.fromOffset(0,6), Size = UDim2.new(0,3,1,-12), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), c.Radius or 0)
		end
		if c.Hover == "Accent" then
			local hovT = c.Outline == "Strong" and 0 or 0.45
			x.connect(r.MouseEnter, function() Tw(x, s, {Color = Theme.Accent, Transparency = hovT}, 0.15) end)
			x.connect(r.MouseLeave, function() Tw(x, s, {Color = Theme.Border, Transparency = t0}, 0.15) end)
		end
		Tag(x, r, "ROWS", 3)
		if click then CK.BindEffects(x, r, fxOpt) end
		return r
	end

	function CK.RowLabel(x, r, it, w)
		return x.label(r, it, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1, w or -170, 1, 0), TextColor3 = "@TextRow", Font = x.FM, TextSize = 12 + x.d, TextXAlignment = XL})
	end

	function CK.Section(x, parent, it, order)
		local c = x.c
		local h = New("TextButton", parent, {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = order})
		local lx = 2
		local labParent, labProps = h, nil
		if c.Section == "Bar" then
			Round(New("Frame", h, {Size = UDim2.fromOffset(3,12), Position = UDim2.fromOffset(2,5), BackgroundColor3 = "@Accent", BorderSizePixel = 0}), 2)
			lx = 12
		elseif c.Section == "Line" then
			New("Frame", h, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,0,1,0), Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
		elseif c.Section == "Chip" then
			labParent = Round(New("Frame", h, {Position = UDim2.fromOffset(0,2), Size = UDim2.fromOffset(0,18), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = "@Accent",
				BackgroundTransparency = 0.85, BorderSizePixel = 0}), 9)
			labProps = true
		end
		local lab
		if labProps then
			lab = x.label(labParent, it, {Position = UDim2.fromOffset(0,0), Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, TextColor3 = "@Accent", Font = x.FB,
				TextSize = 11 + x.d, TextXAlignment = XC})
			New("UIPadding", lab, {PaddingLeft = UDim.new(0,9), PaddingRight = UDim.new(0,9)})
		else
			lab = x.label(labParent, it, {Position = UDim2.fromOffset(lx,0), Size = UDim2.new(1, -lx - 16, 1, 0), TextColor3 = c.Section == "Plain" and "@TextHeader" or "@SubText",
				Font = x.FB, TextSize = 11 + x.d, TextXAlignment = XL})
		end
		local chevron = New("TextLabel", h, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-4,0.5,0), Size = UDim2.fromOffset(16,16), BackgroundTransparency = 1,
			Text = "v", TextColor3 = "@Muted", Font = x.FB, TextSize = 10})
		Tag(x, h, "CONTROLS", 4)
		return h, chevron
	end

	-- returns paint(on)
	function CK.Toggle(x, r)
		local st, rr = x.c.Toggle, x.c.RowRadius
		if st == "Box" then
			local sz, inner = Z(x, 22), Z(x, 10)
			local box = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(sz, sz), BorderSizePixel = 0}), math.min(rr, 6))
			local bs = New("UIStroke", box, {Thickness = 1.5})
			local dot = Round(New("Frame", box, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(0,0), BorderSizePixel = 0}), math.min(rr, 3))
			Tag(x, box, "CONTROLS", 4)
			return function(on)
				Tw(x, box, {BackgroundColor3 = on and Theme.ToggleOn or Theme.Background}, 0.2)
				Tw(x, bs, {Color = on and Theme.Accent or Theme.Border}, 0.2)
				Tw(x, dot, {BackgroundColor3 = Theme.Background, Size = on and UDim2.fromOffset(inner, inner) or UDim2.fromOffset(0,0)}, 0.2)
			end
		elseif st == "Dot" then
			local sz, inner = Z(x, 20), Z(x, 10)
			local ring = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(sz, sz), BorderSizePixel = 0}), 100)
			local rs = New("UIStroke", ring, {Thickness = 1.5})
			local core = Round(New("Frame", ring, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(0,0), BorderSizePixel = 0}), 100)
			Tag(x, ring, "CONTROLS", 4)
			return function(on)
				Tw(x, ring, {BackgroundColor3 = Theme.Background}, 0.2)
				Tw(x, rs, {Color = on and Theme.Accent or Theme.Border}, 0.2)
				Tw(x, core, {BackgroundColor3 = Theme.Accent, Size = on and UDim2.fromOffset(inner, inner) or UDim2.fromOffset(0,0)}, 0.2)
			end
		end
		local tw_, th_, kn = Z(x, 40), Z(x, 20), Z(x, 14)
		local track = Round(New("Frame", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(tw_, th_), BorderSizePixel = 0}), 100)
		local ts = New("UIStroke", track, {Thickness = 1})
		local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(kn, kn), BorderSizePixel = 0}), 100)
		Tag(x, track, "CONTROLS", 4)
		return function(on)
			Tw(x, track, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.2)
			Tw(x, ts, {Color = on and Theme.Accent or Theme.Border}, 0.2)
			Tw(x, knob, {Position = on and UDim2.new(1, -(kn + 3), 0.5, 0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.ToggleKnobOn or Theme.ToggleKnobOff}, 0.2)
		end
	end

	function CK.Slider(x, r, h, it)
		local sty = x.c.Slider
		x.label(r, it, {Position = UDim2.fromOffset(14,8), Size = UDim2.new(1,-110,0,16), TextColor3 = "@TextRow", Font = x.FM, TextSize = 12 + x.d, TextXAlignment = XL})
		local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,8), Size = UDim2.fromOffset(90,16), BackgroundTransparency = 1,
			TextColor3 = "@TextValue", Font = x.FB, TextSize = 11 + x.d, TextXAlignment = XR})
		local th = Z(x, sty == "Thin" and 4 or (sty == "Thick" and 12 or 8))
		local rad = x.c.Radius or 0
		local track = Round(New("Frame", r, {AnchorPoint = Vector2.new(0,0.5), Position = UDim2.fromOffset(14, h - 14), Size = UDim2.new(1,-28,0,th), BackgroundColor3 = "@Background", BorderSizePixel = 0}), rad)
		local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0}), rad)
		local knob
		if sty == "Thin" then
			knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.fromOffset(Z(x,12), Z(x,12)), BackgroundColor3 = "@Text", BorderSizePixel = 0, ZIndex = 3}), 100)
		elseif sty == "Block" then
			knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.fromOffset(6, Z(x,18)), BackgroundColor3 = "@Text", BorderSizePixel = 0, ZIndex = 3}), 2)
		end
		Tag(x, track, "CONTROLS", 4)
		return track, function(a, txt)
			Tw(x, fill, {Size = UDim2.fromScale(a,1)}, 0.08)
			if knob then Tw(x, knob, {Position = UDim2.fromScale(a,0.5)}, 0.08) end
			val.Text = txt
		end
	end

	function CK.Button(x, parent, props)
		local c = x.c
		local sty = c.Button
		local fxOpt = props and props.__fx
		local base = {AutoButtonColor = false, BorderSizePixel = 0, Font = x.FB, TextSize = 11 + x.d, Text = ""}
		if sty == "Filled" then
			base.BackgroundColor3 = "@ButtonFill"; base.TextColor3 = "@ButtonText"
		elseif sty == "Outline" then
			base.BackgroundColor3 = "@ButtonFill"; base.BackgroundTransparency = 1; base.TextColor3 = "@ButtonFill"
		else
			base.BackgroundColor3 = "@Background"; base.TextColor3 = "@Accent"
		end
		for k, v in pairs(props) do if k ~= "__fx" then base[k] = v end end
		local b = Round(New("TextButton", parent, base), c.ButtonRadius)
		if sty == "Outline" then New("UIStroke", b, {Color = "@Accent", Thickness = 1.2}) end
		local rest = sty == "Outline" and 1 or 0
		local hov = sty == "Filled" and 0.2 or (sty == "Outline" and 0.85 or 0.4)
		x.connect(b.MouseEnter, function() Tw(x, b, {BackgroundTransparency = hov}, 0.12) end)
		x.connect(b.MouseLeave, function() Tw(x, b, {BackgroundTransparency = rest}, 0.12) end)
		Tag(x, b, "CONTROLS", 4)
		CK.BindEffects(x, b, fxOpt)
		return b
	end

	function CK.Chrome(x, root, opt)
		local c, FM, FB, d = x.c, x.FM, x.FB, x.d
		local hm, nav = c.Header, c.Nav
		local hh = hm == "Full" and 48 or (hm == "Slim" and 32 or 24)
		local vert = nav == "Left" or nav == "Right"
		local hideLabels = c.NavLabels == "Hide"
		local nw, th = c.NavWidth, c.TabH
		if hideLabels and vert then nw = 56 end
		local navH = th + 12
		local pad = c.Pad
		local ch = {hh = hh, vert = vert, pad = pad}

		local Top = New("Frame", root, {Size = UDim2.new(1,0,0,hh), BackgroundColor3 = "@Secondary", Glass = 0, BorderSizePixel = 0, ZIndex = 3})
		local stripH = c.Strip == "Header"
		New("Frame", Top, {Size = UDim2.new(1,0,0, stripH and 2 or 1), Position = UDim2.new(0,0,1, stripH and -2 or -1), BackgroundColor3 = stripH and "@Accent" or "@Border", BorderSizePixel = 0, ZIndex = 3})
		ch.Top = Top
		Tag(x, Top, "LAYOUT", 2)
		local center = c.TitleAlign == "Center"
		if hm ~= "Bare" then
			local tp = {TextColor3 = "@Text", Font = FB, TextSize = (hm == "Full" and 17 or 13) + d, TextXAlignment = center and XC or XL, ZIndex = 4,
				Size = UDim2.fromOffset(300, hm == "Full" and 22 or 32)}
			if center then
				tp.AnchorPoint = Vector2.new(0.5,0)
				tp.Position = UDim2.new(0.5,0,0, hm == "Full" and 6 or 0)
			else
				tp.Position = hm == "Full" and UDim2.fromOffset(18,6) or UDim2.fromOffset(14,0)
			end
			ch.Title = x.label(Top, opt.title, tp)
			Tag(x, ch.Title, "BRANDING", 5)
			if hm == "Full" then
				local sp = {Size = UDim2.fromOffset(380,14), BackgroundTransparency = 1, TextColor3 = "@Muted", Font = FM, TextSize = 9, TextXAlignment = center and XC or XL, ZIndex = 4}
				if center then sp.AnchorPoint = Vector2.new(0.5,0); sp.Position = UDim2.new(0.5,0,0,27) else sp.Position = UDim2.fromOffset(18,27) end
				ch.Sub = New("TextLabel", Top, sp)
				Tag(x, ch.Sub, "BRANDING", 5)
			end
		end
		local bs = hm == "Full" and 28 or (hm == "Slim" and 24 or 18)
		function ch.TopBtn(text, color, slot, cb)
			local b = Round(New("TextButton", Top, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1, -(12 + slot * (bs + 6)), 0.5, 0), Size = UDim2.fromOffset(bs, bs),
				BackgroundColor3 = "@Row", Text = text, TextColor3 = color, Font = FB, TextSize = hm == "Full" and 14 or 11, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 4}), math.min(c.ButtonRadius, 7))
			x.connect(b.MouseEnter, function() Tw(x, b, {BackgroundColor3 = Theme.Border}, 0.12) end)
			x.connect(b.MouseLeave, function() Tw(x, b, {BackgroundColor3 = Theme.Row}, 0.12) end)
			if cb then x.connect(b.MouseButton1Click, cb) end
			return b
		end

		local sideSize, sidePos, sideAnchor, contPos, contSize, sepPos, sepSize
		if nav == "Left" then
			sideSize, sidePos = UDim2.new(0,nw,1,-hh), UDim2.fromOffset(0,hh)
			contPos, contSize = UDim2.fromOffset(nw,hh), UDim2.new(1,-nw,1,-hh)
			sepPos, sepSize = UDim2.new(1,-1,0,0), UDim2.new(0,1,1,0)
		elseif nav == "Right" then
			sideSize, sidePos = UDim2.new(0,nw,1,-hh), UDim2.new(1,-nw,0,hh)
			contPos, contSize = UDim2.fromOffset(0,hh), UDim2.new(1,-nw,1,-hh)
			sepPos, sepSize = UDim2.new(0,0,0,0), UDim2.new(0,1,1,0)
		elseif nav == "Top" then
			sideSize, sidePos = UDim2.new(1,0,0,navH), UDim2.fromOffset(0,hh)
			contPos, contSize = UDim2.fromOffset(0, hh + navH), UDim2.new(1,0,1, -(hh + navH))
			sepPos, sepSize = UDim2.new(0,0,1,-1), UDim2.new(1,0,0,1)
		else
			sideSize, sidePos, sideAnchor = UDim2.new(1,0,0,navH), UDim2.fromScale(0,1), Vector2.new(0,1)
			contPos, contSize = UDim2.fromOffset(0,hh), UDim2.new(1,0,1, -(hh + navH))
			sepPos, sepSize = UDim2.new(0,0,0,0), UDim2.new(1,0,0,1)
		end
		local Side = New("Frame", root, {Position = sidePos, Size = sideSize, BackgroundColor3 = "@Secondary", Glass = 0, BorderSizePixel = 0, ZIndex = 2})
		if sideAnchor then Side.AnchorPoint = sideAnchor end
		New("Frame", Side, {Size = sepSize, Position = sepPos, BackgroundColor3 = "@Border", BorderSizePixel = 0, ZIndex = 2})
		ch.Side = Side
		Tag(x, Side, "TABS", 2)
		ch.Content = New("Frame", root, {Position = contPos, Size = contSize, BackgroundTransparency = 1, ClipsDescendants = true})
		Tag(x, ch.Content, "LAYOUT", 1)

		if vert then
			local List = New("ScrollingFrame", Side, {Size = UDim2.new(1,0,1, opt.hint and not hideLabels and -30 or 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = c.Scroll,
				ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", List, {Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder})
			New("UIPadding", List, {PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,6)})
			ch.List = List
			if opt.hint and not hideLabels then
				ch.Hint = New("TextLabel", Side, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,14,1,-10), Size = UDim2.new(1,-28,0,14), BackgroundTransparency = 1,
					TextColor3 = "@Muted", Font = FM, TextSize = 9, TextXAlignment = XL, ZIndex = 4})
			end
		else
			local List = New("ScrollingFrame", Side, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X})
			New("UIListLayout", List, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center})
			New("UIPadding", List, {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), PaddingTop = UDim.new(0,6), PaddingBottom = UDim.new(0,6)})
			ch.List = List
			local hov = false
			x.connect(Side.MouseEnter, function() hov = true end)
			x.connect(Side.MouseLeave, function() hov = false end)
			x.connect(UserInputService.InputChanged, function(input)
				if hov and input.UserInputType == Enum.UserInputType.MouseWheel then
					local mx = math.max(List.AbsoluteCanvasSize.X - List.AbsoluteSize.X, 0)
					List.CanvasPosition = Vector2.new(math.clamp(List.CanvasPosition.X - input.Position.Z * 60, 0, mx), 0)
				end
			end)
		end

		local sty = c.NavStyle
		local solid = sty == "Pill" or sty == "Block"
		local icon = c.TabIcon
		if hideLabels and icon == "None" then icon = "Letter" end
		local tr = c.TabRadius
		function ch.AddTab(order, labelFn, fxOpt)
			local bprops = {BackgroundColor3 = solid and "@Accent" or "@Row", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = order, Active = true}
			if vert then
				bprops.Size = UDim2.new(1,0,0,th)
			elseif hideLabels then
				bprops.Size = UDim2.new(0, th + 8, 1, 0)
			else
				bprops.Size = UDim2.new(0,0,1,0); bprops.AutomaticSize = Enum.AutomaticSize.X
			end
			local b = New("TextButton", ch.List, bprops)
			Round(b, sty == "Pill" and 100 or (sty == "Underline" and 0 or tr))
			local bar = Round(New("Frame", b, {BackgroundColor3 = "@TabActive", BorderSizePixel = 0, Visible = false}), 2)
			if sty == "Bar" then
				if vert then bar.Position = UDim2.fromOffset(0, (th - 20) / 2); bar.Size = UDim2.fromOffset(3,20)
				else bar.AnchorPoint = Vector2.new(0.5,1); bar.Position = UDim2.new(0.5,0,1,-3); bar.Size = UDim2.fromOffset(22,3) end
			elseif sty == "Underline" then
				if vert then bar.Position = UDim2.fromOffset(0,4); bar.Size = UDim2.new(0,2,1,-8)
				else bar.AnchorPoint = Vector2.new(0,1); bar.Position = UDim2.new(0,0,1,0); bar.Size = UDim2.new(1,0,0,2) end
			end
			local inset = icon == "None" and 16 or (icon == "Dot" and 28 or 38)
			local lab
			if vert then
				lab = labelFn(b, {Position = UDim2.fromOffset(inset,0), Size = UDim2.new(1,-inset,1,0), BackgroundTransparency = 1, TextColor3 = Theme.SubText, Font = FB, TextSize = 11 + d,
					TextXAlignment = XL, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Visible = not hideLabels})
			else
				lab = labelFn(b, {Position = UDim2.fromOffset(0,0), Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, TextColor3 = Theme.SubText,
					Font = FB, TextSize = 11 + d, TextXAlignment = XC, ZIndex = 2, Visible = not hideLabels})
				New("UIPadding", lab, {PaddingLeft = UDim.new(0, icon == "None" and 14 or inset - 4), PaddingRight = UDim.new(0,14)})
			end
			local badge, badgeText
			local bx = hideLabels and 0.5 or 0
			local boff = hideLabels and 0 or 8
			if icon == "Dot" then
				badge = Round(New("Frame", b, {AnchorPoint = Vector2.new(hideLabels and 0.5 or 0, 0.5), Position = UDim2.new(bx, hideLabels and 0 or 12, 0.5, 0), Size = UDim2.fromOffset(8,8),
					BackgroundColor3 = Theme.Muted, BorderSizePixel = 0, ZIndex = 3}), 100)
			elseif icon == "Letter" or icon == "Number" then
				badge = Round(New("Frame", b, {AnchorPoint = Vector2.new(hideLabels and 0.5 or 0, 0.5), Position = UDim2.new(bx, boff, 0.5, 0), Size = UDim2.fromOffset(20,20),
					BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 3}), math.min(tr, 6))
				badgeText = New("TextLabel", badge, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", TextColor3 = Theme.SubText, Font = FB, TextSize = 10 + d, ZIndex = 4})
			end
			Tag(x, b, "TABS", 3)
			CK.BindEffects(x, b, fxOpt)
			return {Bg = b, Bar = bar, Label = lab, Badge = badge, BadgeText = badgeText}
		end
		function ch.Paint(btns, name)
			for n, b in pairs(btns) do
				local on = n == name
				if solid then
					b.Bg.BackgroundTransparency = on and 0 or 1
					b.Label.TextColor3 = on and Theme.TabTextActive or Theme.TabText
					b.Bar.Visible = false
				elseif sty == "Underline" then
					b.Bg.BackgroundTransparency = 1
					b.Bar.Visible = false
					b.Label.TextColor3 = on and Theme.TabTextActive or Theme.TabText
				else
					b.Bg.BackgroundTransparency = on and 0 or 1
					b.Bar.Visible = false
					b.Label.TextColor3 = on and Theme.TabTextActive or Theme.TabText
				end
				if b.Bar then b.Bar.Visible = false end
				if b.Badge then
					local sOn = solid and on
					if b.BadgeText then
						Tw(x, b.Badge, {BackgroundColor3 = sOn and Theme.Background or (on and Theme.Accent or Theme.Border)}, 0.15)
						Tw(x, b.BadgeText, {TextColor3 = sOn and Theme.Accent or (on and Theme.Background or Theme.SubText)}, 0.15)
					else
						Tw(x, b.Badge, {BackgroundColor3 = sOn and Theme.Background or (on and Theme.Accent or Theme.Muted)}, 0.15)
					end
				end
			end
		end
		ch.Icon = icon
		return ch
	end

	-- env: refreshers, title, tabs ({Key, label(parent, props), ...}), buildTab(entry, page, C), logic{toggle,slider,choice,bind,info,input,avatar},
	-- baseSub(), hintText(), onLocale(fn), tick(fn), onMin, onClose, draggable(handle, root), saveOrder(keys), loadPos(), savePos(s), isPointer(input),
	-- onLog(scroll), uiScale, backdrop(bool), visible(bool)
	function CK.Build(x, parent, env)
		local c, FM, FB, d = x.c, x.FM, x.FB, x.d
		local logic = env.logic
		local refreshers = env.refreshers
		local scrollCol = c.ScrollColor == "Accent" and "@Accent" or (c.ScrollColor == "Border" and "@Border" or "@Muted")
		local useGrad = c.Gradient ~= "Off"

		local backdrop = nil
		if env.backdrop and c.Backdrop ~= "None" then
			backdrop = New("Frame", parent, {Name = "Backdrop", Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false})
		end
		local Root = New("CanvasGroup", parent, {Name = "Main", AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(c.Width, c.Height),
			BackgroundColor3 = useGrad and Color3.new(1,1,1) or "@Background", Glass = 0, BorderSizePixel = 0, GroupTransparency = env.visible and 0 or 1, Visible = env.visible == true,
			ClipsDescendants = true})
		local Scale = New("UIScale", Root, {Scale = (c.Open == "Pop" and not env.visible) and 0.9 or (env.uiScale or 1)})
		Tag(x, Root, "WINDOW", 1)
		local spin = CK.Frame(x, Root, refreshers)
		if useGrad then
			local g = New("UIGradient", Root, {Rotation = c.Gradient == "Vertical" and 90 or (c.Gradient == "Horizontal" and 0 or 45)})
			local function PaintGrad()
				local a = Theme.Background
				local b2 = c.GradientTint == "Accent" and Mix(a, Theme.Accent, 0.28) or Theme.Secondary
				g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, a), ColorSequenceKeypoint.new(1, b2)})
			end
			PaintGrad(); table.insert(refreshers, PaintGrad)
		end
		if c.Strip == "Top" then
			New("Frame", Root, {Name = "TopStrip", Size = UDim2.new(1,0,0,3), BackgroundColor3 = "@Accent", BorderSizePixel = 0, ZIndex = 10})
		end

		local ch = CK.Chrome(x, Root, {title = (c.Title ~= "" and {raw = c.Title} or env.title), hint = true})
		local Top = ch.Top

		local fps, acc = 60, 0
		local function PaintSub()
			if not ch.Sub then return end
			local base = c.Subtitle ~= "" and c.Subtitle or env.baseSub()
			if c.HeaderInfo == "FPS" then base = base .. "  |  " .. tostring(fps) .. " FPS"
			elseif c.HeaderInfo == "Clock" then base = base .. "  |  " .. os.date("%H:%M:%S") end
			ch.Sub.Text = base
			ch.Sub.Visible = c.HeaderInfo ~= "Hidden"
		end
		PaintSub()
		env.onLocale(PaintSub)
		if ch.Sub and (c.HeaderInfo == "FPS" or c.HeaderInfo == "Clock") then
			env.tick(function(dt)
				acc += dt
				if dt > 0 then fps = math.floor(fps * 0.85 + (1 / dt) * 0.15 + 0.5) end
				if acc >= 0.5 then acc = 0; PaintSub() end
			end)
		end
		if ch.Hint then
			local function PaintHint() ch.Hint.Text = env.hintText() end
			PaintHint(); env.onLocale(PaintHint)
			if env.onBind then env.onBind(PaintHint) end
		end
		ch.TopBtn("-", Theme.Text, 0, env.onMin)
		ch.TopBtn("X", Color3.fromRGB(255,90,100), 1, env.onClose)
		if env.draggable then env.draggable(Top, Root) end

		local C = {}
		local function row(cx, h, click)
			cx.n += 1
			local parentF = cx.group or cx.page
			local order = cx.group and cx.gn or cx.n
			if cx.group then cx.gn = (cx.gn or 0) + 1 end
			return CK.Row(x, parentF, h, click, order)
		end
		function C.section(it, cx)
			cx.n += 1
			local h, chevron = CK.Section(x, cx.page, it, cx.n)
			cx.n += 1
			local group = New("Frame", cx.page, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = cx.n})
			New("UIListLayout", group, {Padding = UDim.new(0, c.RowGap), SortOrder = Enum.SortOrder.LayoutOrder})
			cx.group, cx.gn = group, 1
			if env.collapse then env.collapse(h, group, chevron) end
		end
		function C.label(it, cx)
			cx.n += 1
			local parentF = cx.group or cx.page
			local h = New("Frame", parentF, {Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, LayoutOrder = cx.group and cx.gn or cx.n})
			if cx.group then cx.gn = (cx.gn or 0) + 1 end
			x.label(h, it, {Position = UDim2.fromOffset(2,0), Size = UDim2.new(1,-4,1,0), TextColor3 = "@SubText", Font = FM, TextSize = 11 + d, TextXAlignment = XL})
		end
		function C.toggle(it, cx)
			local r = row(cx, c.RowH, true, it)
			CK.RowLabel(x, r, it, -70)
			logic.toggle(it, r, CK.Toggle(x, r))
		end
		function C.slider(it, cx)
			local h = c.RowH + 14
			local r = row(cx, h)
			local track, paint = CK.Slider(x, r, h, it)
			logic.slider(it, r, track, paint)
		end
		local function pickBtn(r, it)
			return CK.Button(x, r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(Z(x,130), Z(x,26)), __fx = it})
		end
		function C.choice(it, cx)
			local r = row(cx, c.RowH); CK.RowLabel(x, r, it)
			local b = pickBtn(r, it)
			logic.choice(it, b, function(t) b.Text = t end)
		end
		function C.bind(it, cx)
			local r = row(cx, c.RowH); CK.RowLabel(x, r, it)
			local b = pickBtn(r, it)
			logic.bind(it, b, function(t) b.Text = t end)
		end
		function C.action(it, cx)
			local r = row(cx, c.RowH)
			local b = CK.Button(x, r, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-24,1,-12), __fx = it})
			env.bindText(b, it)
			x.connect(b.MouseButton1Click, it.fn or function() end)
		end
		C.button = C.action
		function C.separator(it, cx)
			cx.n += 1
			local parentF = cx.group or cx.page
			local f = New("Frame", parentF, {Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0, LayoutOrder = cx.group and cx.gn or cx.n})
			if cx.group then cx.gn = (cx.gn or 0) + 1 end
		end
		function C.spacer(it, cx)
			cx.n += 1
			local parentF = cx.group or cx.page
			local f = New("Frame", parentF, {Size = UDim2.new(1,0,0,math.max(1, tonumber(it.h) or 10)), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = cx.group and cx.gn or cx.n})
			if cx.group then cx.gn = (cx.gn or 0) + 1 end
		end
		function C.image(it, cx)
			local r = row(cx, tonumber(it.h) or 120)
			local img = Round(New("ImageLabel", r, {Position = UDim2.fromOffset(10,10), Size = UDim2.new(1,-20,1,-20), BackgroundTransparency = 1, Image = tostring(it.image or ""), ScaleType = Enum.ScaleType.Fit}), math.min(c.RowRadius, 8))
			if it.text and it.text ~= "" then
				New("TextLabel", r, {AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-6), Size = UDim2.new(1,-20,0,18), BackgroundColor3 = "@Background", BackgroundTransparency = 0.2, Text = it.text, TextColor3 = "@Text", Font = FB, TextSize = 11, ZIndex = 3})
			end
		end
		function C.input(it, cx)
			local r = row(cx, it.h)
			local box = Round(logic.input(r, it, {Position = UDim2.fromOffset(14,8), Size = UDim2.new(1,-28,1,-16), BackgroundColor3 = "@Background", BorderSizePixel = 0}), math.min(c.RowRadius, 6))
			New("UIStroke", box, {Color = "@Border", Thickness = 1})
			New("UIPadding", box, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
		end
		function C.info(it, cx)
			local r = row(cx, c.RowH); CK.RowLabel(x, r, it, -300)
			local v = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.fromOffset(280,20), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = FB, TextSize = 12 + d, TextXAlignment = XR, TextTruncate = Enum.TextTruncate.AtEnd})
			logic.info(v, it)
		end
		function C.log(it, cx)
			local r = row(cx, math.clamp(c.Height - 140, 200, 340))
			local s = New("ScrollingFrame", r, {Position = UDim2.fromOffset(10,10), Size = UDim2.new(1,-20,1,-20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = c.Scroll,
				ScrollBarImageColor3 = scrollCol, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
			New("UIListLayout", s, {Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})
			env.onLog(s)
		end
		function C.avatar(it, cx)
			local r = row(cx, 96)
			local img = logic.avatar(r, 72); img.Position = UDim2.fromOffset(12,12)
			New("TextLabel", r, {Position = UDim2.fromOffset(94,30), Size = UDim2.new(1,-110,0,24), BackgroundTransparency = 1, Text = env.userName, TextColor3 = "@Text", Font = FB, TextSize = 16, TextXAlignment = XL})
			New("TextLabel", r, {Position = UDim2.fromOffset(94,54), Size = UDim2.new(1,-110,0,16), BackgroundTransparency = 1, Text = "@" .. env.displayName, TextColor3 = "@SubText", Font = FM, TextSize = 11, TextXAlignment = XL})
		end

		local order = {}
		for _, e in ipairs(env.tabs) do table.insert(order, e) end
		local Pages, Btns, Active = {}, {}, nil
		local PaintBadges
		local function Select(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			ch.Paint(Btns, name)
		end
		table.insert(refreshers, function() if Active then Select(Active) end end)

		for i, e in ipairs(order) do
			local page = New("ScrollingFrame", ch.Content, {Name = e.Key, Position = UDim2.fromOffset(ch.pad, ch.pad), Size = UDim2.new(1, -2 * ch.pad, 1, -2 * ch.pad), BackgroundTransparency = 1,
				BorderSizePixel = 0, ScrollBarThickness = c.Scroll, ScrollBarImageColor3 = scrollCol, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false})
			New("UIListLayout", page, {Padding = UDim.new(0, c.RowGap), SortOrder = Enum.SortOrder.LayoutOrder})
			New("UIPadding", page, {PaddingRight = UDim.new(0,8), PaddingBottom = UDim.new(0,10)})
			Pages[e.Key] = page
			local tabFx = {events = {
				hoverEnter = {effects = (e.def and e.def.fx and e.def.fx.hover) or ((CK.Custom.Effects and CK.Custom.Effects.TabHover) or CK.Custom.Effects.Hover), sound = (CK.Custom.Effects and CK.Custom.Effects.TabSound)},
				click = {effects = (e.def and e.def.fx and e.def.fx.click) or ((CK.Custom.Effects and CK.Custom.Effects.Tab) or CK.Custom.Effects.Click), sound = (CK.Custom.Effects and CK.Custom.Effects.TabSound)},
			}}
			local b = ch.AddTab(i, e.label, tabFx)
			Btns[e.Key] = b
			x.connect(b.Bg.MouseButton1Click, function() Select(e.Key) end)
			env.buildTab(e, page, C)
		end
		PaintBadges = function()
			for i, e in ipairs(order) do
				local b = Btns[e.Key]
				if b and b.BadgeText then
					if c.TabIcon == "Number" then
						b.BadgeText.Text = tostring(i)
					else
						local t = b.Label.Text or ""
						local first = ""
						if t ~= "" then
							local off = utf8.offset(t, 2)
							first = off and string.sub(t, 1, off - 1) or t
						end
						b.BadgeText.Text = string.upper(first)
					end
				end
			end
		end
		PaintBadges()
		env.onLocale(PaintBadges)
		Select(env.startTab or order[1].Key)


		if env.loadPos then
			local rx, ry = string.match(env.loadPos() or "", "^(-?%d+),(-?%d+)$")
			if rx then Root.Position = UDim2.new(0.5, tonumber(rx), 0.5, tonumber(ry)) end
		end
		if env.savePos then
			local wasDragging = false
			x.connect(Top.InputBegan, function(i) if env.isPointer(i) then wasDragging = true end end)
			x.connect(UserInputService.InputEnded, function(input)
				if wasDragging and env.isPointer(input) then
					wasDragging = false
					task.defer(function() env.savePos(math.floor(Root.Position.X.Offset) .. "," .. math.floor(Root.Position.Y.Offset)) end)
				end
			end)
		end

		local home, shown = Root.Position, env.visible == true
		local sp = x.speed
		local function Show(state, uiScale, uiOpacity, isOpen)
			if backdrop then
				if state then
					backdrop.Visible = true
					Tween(backdrop, {BackgroundTransparency = c.Backdrop == "Dark" and 0.25 or 0.55}, 0.25 * sp)
				else
					Tween(backdrop, {BackgroundTransparency = 1}, 0.2 * sp)
					task.delay(0.22 * sp, function() if not isOpen() and backdrop.Parent then backdrop.Visible = false end end)
				end
			end
			local function hideLater()
				task.delay(0.22 * sp, function() if not isOpen() and Root.Parent then Root.Visible = false end end)
			end
			if c.Open == "Fade" then
				if state then
					Root.Visible = true; Scale.Scale = uiScale
					Tween(Root, {GroupTransparency = uiOpacity}, 0.25 * sp)
				else
					Tween(Root, {GroupTransparency = 1}, 0.2 * sp); hideLater()
				end
			elseif c.Open == "Slide" then
				if state then
					if not shown then
						Root.Position = UDim2.new(home.X.Scale, home.X.Offset, home.Y.Scale, home.Y.Offset + 40)
					end
					Root.Visible = true; Scale.Scale = uiScale
					Tween(Root, {Position = home, GroupTransparency = uiOpacity}, 0.3 * sp)
					shown = true
				else
					if shown then home = Root.Position end
					shown = false
					Tween(Root, {Position = UDim2.new(home.X.Scale, home.X.Offset, home.Y.Scale, home.Y.Offset + 40), GroupTransparency = 1}, 0.2 * sp); hideLater()
				end
			else
				if state then
					Root.Visible = true
					Tween(Scale, {Scale = uiScale}, 0.32 * sp, Enum.EasingStyle.Back)
					Tween(Root, {GroupTransparency = uiOpacity}, 0.22 * sp)
				else
					Tween(Scale, {Scale = uiScale * 0.94}, 0.2 * sp)
					Tween(Root, {GroupTransparency = 1}, 0.2 * sp); hideLater()
				end
			end
			local extra = CK.Custom and CK.Custom.Effects
			if extra then
				CK.PlayEffects(Root, state and extra.OpenExtra or extra.Close, {duration = 0.18 * sp, color = extra.Color, color2 = extra.Color2})
				local soundId = state and extra.OpenSound or extra.CloseSound
				if soundId and soundId ~= "" then FxSound(Root, soundId, extra.Volume, 1) end
			end
		end

		return {
			Root = Root, Select = Select, Show = Show, Ch = ch,
			SetScale = function(v) Tween(Scale, {Scale = v}, 0.1) end,
			SetOpacity = function(v) Tween(Root, {GroupTransparency = v}, 0.1) end,
			Destroy = function()
				if spin then spin:Cancel() end
				if backdrop then backdrop:Destroy() end
				Root:Destroy()
			end,
		}
	end
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
		ShowHeadDot = true, ShowWeapon = true, ItemESPEnabled = true, WeaponESPEnabled = true, WorldESPMaxDistance = 1800, ShowOffscreen = true, ChamsEnabled = true, ESPColor = "Red", ESPMaxDistance = 4000, ShowTracers = true,
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
		ShowHeadDot = false, ShowWeapon = false, ItemESPEnabled = false, WeaponESPEnabled = false, WorldESPMaxDistance = 1200, ShowOffscreen = false, ChamsEnabled = false, ESPColor = "White", ESPMaxDistance = 1500, ShowTracers = false,
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

DebugLog = {List = {}, Map = {}, Max = 300}
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
local SafeLastNotify = {}
local function Safe(mod, fn, ...)
	local ok, err = pcall(fn, ...)
	if not ok then
		DebugLog.Push(mod, tostring(err), true)
		local now = os.clock()
		if now - (SafeLastNotify[mod] or 0) >= 3 then
			SafeLastNotify[mod] = now
			warn("[Vortex][" .. mod .. "] " .. tostring(err))
		end
	end
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

local RunSkinBuilder

-- Compiler-safe player bootstrap: keep the iterator locals out of LaunchHub's giant scope.
local function RegisterExistingPlayers(EspRef, LocalPlayerRef)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayerRef then
			EspRef.NewPlayerEntry(p)
		end
	end
end

local function LaunchHub(skinName)
	-- crez_fix: LaunchHub used to declare ~100 bare local functions + state locals directly in its
	-- own scope, which blew past Luau's 200-local-register cap per function (CompileError, whole
	-- chunk failed to compile, nothing ran). Grouping them into a handful of namespace tables below
	-- collapses that to ~10 locals; every call site was mechanically rewritten to NS.Name(...).
	local Core, Move, AimFn, Trig, Esp, Scene, FxFn, Cfg, Bld = {}, {}, {}, {}, {}, {}, {}, {}, {}
	local pref = SkinThemes[skinName] or SkinThemes.Sidebar
	Prefs.Theme, Prefs.Accent = pref[1], pref[2]
	ApplyTheme()
	DebugLog.Push("system", "hub init, skin = " .. skinName .. ", theme = " .. Prefs.Theme)

	local S = {
		ShowLimb = true,
		CrosshairOutline = true,
		AimbotEnabled = false, AimHold = true, AimTeamCheck = true, AimIgnoreBots = false, VisibleCheck = true, AimPart = "Head", AimSpeed = 14,
		FOVRadius = 150, MaxAimDistance = 1500, PredictionEnabled = false, PredictionTime = 0.12, ShowFOV = true, ShowTargetLine = false,
		TriggerEnabled = false, TriggerTeamCheck = true, TriggerIgnoreBots = false, TriggerWallCheck = true, TriggerFOV = 5, TriggerHitbox = true, TriggerPart = "Any",
		TriggerMaxDistance = 1000, TriggerDelay = 0.05, TriggerInterval = 0.1, TriggerHumanize = true, TriggerOnlyAim = false,
		ShowTriggerFOV = true, TriggerClickMode = "Auto",
		ESPEnabled = true, ESPTeamCheck = true, ESPIgnoreBots = false, ShowBoxes = true, ShowNames = true, ShowDistance = true, ShowHealth = true,
		ShowSkeleton = true, ShowHeadDot = false, ShowWeapon = false,
		ItemESPEnabled = false, WeaponESPEnabled = false, WorldESPMaxDistance = 1800, ShowOffscreen = false, ChamsEnabled = false, ESPColor = "Red",
		ESPMaxDistance = 3000, ShowTracers = false, TracerOrigin = "Bottom", CornerBoxEnabled = false,
		SpeedEnabled = false, SpeedValue = 32, JumpEnabled = false, JumpValue = 80, FlyEnabled = false, FlySpeed = 70,
		NoclipEnabled = false, InfJumpEnabled = false,
		FullBrightEnabled = false, NoShadowsEnabled = false, CustomFOVEnabled = false, CameraFOV = 90, ZoomEnabled = false, ZoomFOV = 25,
		FreecamEnabled = false, FreecamSpeed = 60, ZoomLimitEnabled = false, ZoomLimit = 120,
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
		MenuStyle = skinName, AntiAFKEnabled = false, ClickTPEnabled = false, FPSCapEnabled = false, FPSCapValue = 240,
		AimPriority = "Closest to Crosshair", AimPredictionMultiplier = 1, PredictionHorizontal = true, PredictionVertical = true,
		AimSmoothness = 0.9, AimAcceleration = 18, AimDeceleration = 22, DynamicFOVEnabled = false, FOVDistanceScale = 0.35,
		TargetLockEnabled = true, TargetSwitchDelay = 0.08, TargetIndicatorEnabled = true, AimAllowNPC = false, AimAllowBots = false, AimFOVColorName = "Theme",
		TriggerPriority = "Closest to Crosshair", TriggerMinInterval = 0.06, TriggerMaxInterval = 0.16, TriggerRandomDelay = 0.06,
		TriggerBurstEnabled = false, TriggerBurstCount = 3, TriggerBurstDelay = 0.045, TriggerCooldownIndicator = true,
		TriggerAllowNPC = false, TriggerAllowBots = false, TriggerBodyMode = "Any", TriggerJitter = 0.03,
		PlayerESPEnabled = true, NPCESPEnabled = true, BotESPEnabled = true, ESPHealthPercent = false, ESPHealthGradient = true,
		ESPVisibilityColor = false, ESPVisibleColor = "Green", ESPHiddenColor = "Red", ESPDynamicColor = false, ESPRainbow = false, ESPRainbowSpeed = 0.2, ESPTeamColors = false,
		ESPTargetHighlight = true, ESPTargetColorName = "Theme", KillMarkerEnabled = false,
		AirWalkEnabled = false, NoFallEnabled = false, BunnyHopEnabled = false, BunnyHopInterval = 0.12,
		MoveForwardKey = "W", MoveBackKey = "S", MoveLeftKey = "A", MoveRightKey = "D", MoveUpKey = "Space", MoveDownKey = "LeftControl",
		CameraSmoothing = 16, FOVTransitionSpeed = 16, CameraShakeEnabled = false, CameraShakeIntensity = 0.8, CameraShakeSpeed = 16,
		CrosshairStyle = "Classic", CrosshairLength = 10, CrosshairRotation = 0, CrosshairOutline = true, CrosshairOutlineThickness = 1,
		CrosshairSpread = 0, CrosshairSpreadSpeed = 8, CrosshairDynamicAmount = 6, CrosshairTargetColorName = "Red",
		RenderPreset = "Clean", DebugMode = false, PerformanceMode = false,
		BindMenuMode = "Toggle", BindAimbotMode = "Toggle", BindTriggerMode = "Toggle", BindESPMode = "Toggle", BindFlyMode = "Toggle",
		BindSpeedMode = "Toggle", BindNoclipMode = "Toggle", BindFreecamMode = "Toggle", BindZoomMode = "Hold",
	}
	for k, v in pairs(S) do
		if type(v) == "boolean" and string.sub(k, -7) == "Enabled" then S[k] = false end
	end
	local Defaults = {}
	for k, v in pairs(S) do Defaults[k] = v end

	local K = {
		Menu = Enum.KeyCode.RightShift, AimbotEnabled = Enum.KeyCode.Q, TriggerEnabled = Enum.KeyCode.T, ESPEnabled = Enum.KeyCode.F2,
		FlyEnabled = Enum.KeyCode.F, SpeedEnabled = Enum.KeyCode.V, NoclipEnabled = Enum.KeyCode.Unknown,
		FreecamEnabled = Enum.KeyCode.P, Zoom = Enum.KeyCode.C,
	}
	local BindNameKeys = {AimbotEnabled = "OPT_AIMBOT", TriggerEnabled = "OPT_TRIGGERBOT", ESPEnabled = "OPT_ESP", FlyEnabled = "OPT_FLY",
		SpeedEnabled = "OPT_SPEED", NoclipEnabled = "OPT_NOCLIP", FreecamEnabled = "OPT_FREECAM"}
	local BindOrder = {"AimbotEnabled", "TriggerEnabled", "ESPEnabled", "FlyEnabled", "SpeedEnabled", "NoclipEnabled", "FreecamEnabled"}
	K.Panic, K.Unload = Enum.KeyCode.Delete, Enum.KeyCode.End

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
	local WorldKeys = {"FullBrightEnabled","NoShadowsEnabled","ExposureEnabled","Exposure","HideCloudsEnabled","GravityEnabled","GravityValue","ZoomLimitEnabled","ZoomLimit",
		"SnowEnabled","SnowIntensity","RainEnabled","RainIntensity","WindStrength","FogEnabled","FogDensity","FogColorName",
		"LightningEnabled","LightningInterval","AtmosphereEnabled","AtmoDensity","AtmoHaze","AtmoColorName","SunRaysEnabled","SunRaysIntensity",
		"SunRaysSpread","RainbowEnabled","RainbowSpeed","TimeOfDayEnabled","TimeOfDay","TimeFlowEnabled","TimeFlowSpeed","GlowEnabled",
		"GlowIntensity","GlowSize","ColorGradeEnabled","ColorSaturation","ColorContrast","ColorBrightness","ColorTintName","VisionMode","DOFEnabled","DOFFocus","DOFFar","DOFNear","DOFRadius",
		"BlurEnabled","BlurSize","VignetteEnabled","VignetteIntensity",
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
	local PresetNames = {"None", "Clean", "Competitive", "Dark", "Bright", "Cinematic", "Performance", "Thunderstorm", "Blizzard", "Golden Hour", "Cyber Night", "Foggy Dawn", "Clear Night", "Volcanic", "Faded Film"}
	Presets.Clean = {FullBrightEnabled = false, NoShadowsEnabled = false, ExposureEnabled = false, GlowEnabled = false, ColorGradeEnabled = false,
		AtmosphereEnabled = false, FogEnabled = false, SnowEnabled = false, RainEnabled = false, AshEnabled = false, StarsEnabled = false, VignetteEnabled = false}
	Presets.Competitive = {FullBrightEnabled = true, NoShadowsEnabled = true, ExposureEnabled = true, Exposure = 0.3, GlowEnabled = false,
		ColorGradeEnabled = true, ColorSaturation = -0.1, ColorContrast = 0.12, ColorBrightness = 0.05, ColorTintName = "None", FogEnabled = false, VignetteEnabled = false}
	Presets.Dark = {FullBrightEnabled = false, NoShadowsEnabled = false, ExposureEnabled = true, Exposure = -0.8, GlowEnabled = false,
		ColorGradeEnabled = true, ColorSaturation = -0.25, ColorContrast = 0.2, ColorBrightness = -0.05, ColorTintName = "Purple", VignetteEnabled = true, VignetteIntensity = 0.5}
	Presets.Bright = {FullBrightEnabled = true, NoShadowsEnabled = true, ExposureEnabled = true, Exposure = 0.7, GlowEnabled = true, GlowIntensity = 0.3,
		ColorGradeEnabled = true, ColorSaturation = 0.1, ColorContrast = 0.05, ColorBrightness = 0.08, ColorTintName = "None", VignetteEnabled = false}
	Presets.Cinematic = {FullBrightEnabled = false, NoShadowsEnabled = false, ExposureEnabled = true, Exposure = -0.15, GlowEnabled = true, GlowIntensity = 0.45, GlowSize = 28,
		ColorGradeEnabled = true, ColorSaturation = -0.05, ColorContrast = 0.18, ColorBrightness = -0.02, ColorTintName = "Sepia", AtmosphereEnabled = true, AtmoDensity = 0.3, AtmoHaze = 1.7,
		SunRaysEnabled = true, SunRaysIntensity = 0.25, DOFEnabled = true, DOFFar = 0.2, DOFNear = 0.03, VignetteEnabled = true, VignetteIntensity = 0.35}
	Presets.Performance = {FullBrightEnabled = false, NoShadowsEnabled = true, ExposureEnabled = false, GlowEnabled = false, ColorGradeEnabled = false, AtmosphereEnabled = false,
		FogEnabled = false, SnowEnabled = false, RainEnabled = false, AshEnabled = false, StarsEnabled = false, SunRaysEnabled = false, DOFEnabled = false, BlurEnabled = false, VignetteEnabled = false}

	local R15Bones = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
		{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
		{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
	local R6Bones = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
	local R15Names = {"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg"}
	local R6Names = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}

	local Conns, Sync, Hooks, Entries, Widgets, Infos, OnBind = {}, {}, {}, {}, {}, {}, {}
local EntryOrder, EntryIndex = {}, {}
	local Unloaded, Listening, Skin = false, nil, nil
	local QoL = {LastAFK = os.clock(), FPSCapApplied = nil}
	local MenuState = {Open = false}
	local SessionStart = os.clock()
	local Drag = {}
	local Skins = {}

	function Core.Connect(sig, cb)
		if not sig or type(cb) ~= "function" then
			if DebugLog and DebugLog.Push then DebugLog.Push("event", "invalid connection request", true) end
			return nil
		end
		local wrapped = function(...)
			local ok, err = pcall(cb, ...)
			if not ok and DebugLog and DebugLog.Push then DebugLog.Push("event", tostring(err), true) end
		end
		local ok, conn = pcall(function() return sig:Connect(wrapped) end)
		if not ok or not conn then
			if DebugLog and DebugLog.Push then DebugLog.Push("event", "failed to connect: " .. tostring(conn), true) end
			return nil
		end
		table.insert(Conns, conn)
		return conn
	end

	-- crez_collapse_v2: old version put one InputChanged connection PER collapsible section (~60+ across
	-- all 7 skins combined), each firing on every mouse-wheel tick application-wide regardless of relevance.
	-- One global listener + a hover registry does the same job at O(1) connections instead of O(sections).
	local CollapseRegistry = {}
	local CollapseHoverCount = 0
	do
		Core.Connect(UserInputService.InputChanged, function(input)
			if CollapseHoverCount == 0 then return end
			if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
			local up = input.Position.Z > 0
			for i = #CollapseRegistry, 1, -1 do
				local e = CollapseRegistry[i]
				if e.header.Parent == nil then
					table.remove(CollapseRegistry, i)
				elseif e.hovering then
					if up and not e.collapsed then e.collapsed = true; e.paint()
					elseif (not up) and e.collapsed then e.collapsed = false; e.paint() end
				end
			end
		end)
	end
	function Core.CollapseOnScroll(header, group, chevron)
		local e = {header = header, collapsed = false, hovering = false}
		function e.paint()
			group.Visible = not e.collapsed
			if chevron then Tween(chevron, {Rotation = e.collapsed and -90 or 0}, 0.15) end
		end
		Core.Connect(header.MouseEnter, function() if not e.hovering then e.hovering = true; CollapseHoverCount += 1 end end)
		Core.Connect(header.MouseLeave, function() if e.hovering then e.hovering = false; CollapseHoverCount -= 1 end end)
		table.insert(CollapseRegistry, e)
		return {IsCollapsed = function() return e.collapsed end}
	end

	function Core.SetValue(key, value)
		if S[key] == nil then DebugLog.Push("state", "ignored unknown setting: " .. tostring(key), true); return false end
		S[key] = value
		if Sync[key] then for _, fn in ipairs(Sync[key]) do local ok, err = pcall(fn); if not ok then DebugLog.Push("watch", tostring(err), true) end end end
		if Hooks[key] then local ok, err = pcall(Hooks[key], value); if not ok then DebugLog.Push("hook", key .. ": " .. tostring(err), true) end end
		return true
	end
	function Core.Watch(key, fn, themed)
		if type(fn) ~= "function" then return function() end end
		local syncList
		if key then Sync[key] = Sync[key] or {}; syncList = Sync[key]; table.insert(syncList, fn) end
		if themed then table.insert(Refreshers, fn) end
		local ok, err = pcall(fn); if not ok then DebugLog.Push("watch", tostring(err), true) end
		local active = true
		return function()
			if not active then return end
			active = false
			local function removeOne(list)
				if not list then return end
				for i = #list, 1, -1 do if list[i] == fn then table.remove(list, i); break end end
			end
			removeOne(syncList); removeOne(Refreshers)
			if key and Sync[key] and #Sync[key] == 0 then Sync[key] = nil end
		end
	end
	function Core.KeyName(code) return code == Enum.KeyCode.Unknown and "NONE" or code.Name end
	function Core.TintColor(name)
		if name == "Theme" then return Theme.Accent end
		return WorldTintColors[name] or Color3.fromRGB(255,255,255)
	end
	function Core.IsPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

	local Overlay = New("ScreenGui", PlayerGui, {Name = "VortexOverlay", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 2000})
	-- ESP is isolated from the general overlay and hosted alongside the menu.
	-- Some games put their HUD at a very high PlayerGui DisplayOrder; keeping ESP
	-- in the executor GUI host prevents the game's UI from covering it.
	local ESPOverlay = New("ScreenGui", EspHost, {Name = "VortexESP", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 2147482500, Enabled = true})
	local MenuGui = New("ScreenGui", VortexGuiHost, {Name = "VortexMenu", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 2147483000})

	-- Menu cursor: native pointer only, no overlay sprites or custom cursor rendering.
	local InitialMouseBehavior = UserInputService.MouseBehavior
	local InitialMouseIconEnabled = UserInputService.MouseIconEnabled
	local CursorSys = {ForcedOpen = false, AimPos = Camera.ViewportSize / 2}
	function CursorSys.DestroyVisual() end
	function CursorSys.Set(state)
		state = state == true
		CursorSys.ForcedOpen = state
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
	function CursorSys.Tick()
		local vp = Camera.ViewportSize
		local mouse = UserInputService:GetMouseLocation()
		CursorSys.AimPos = Vector2.new(math.clamp(mouse.X, 0, vp.X), math.clamp(mouse.Y, 0, vp.Y))
	end

	local Toasts = New("Frame", Overlay, {AnchorPoint = Vector2.new(1,1), Position = UDim2.new(1,-16,1,-16), Size = UDim2.fromOffset(240,300), BackgroundTransparency = 1})
	New("UIListLayout", Toasts, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right})
	function Core.Notify(text)
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
	local Trigger = {LastScan = 0, LastFire = 0, EnterTime = nil, NextFire = 0, Player = nil, Part = nil, Target = nil, ScanInterval = 1 / 30, CenterAccum = 0}
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
	local TPParams = RaycastParams.new()
	TPParams.FilterType = Enum.RaycastFilterType.Exclude; TPParams.IgnoreWater = false; TPParams.RespectCanCollide = true

	local function MoveKeyDown(name, fallback)
		local raw = S[name]
		local code = raw and Enum.KeyCode[tostring(raw)] or fallback
		return code and code ~= Enum.KeyCode.Unknown and UserInputService:IsKeyDown(code)
	end
	function Move.MoveDir(rot)
		local d = Vector3.zero
		if MoveKeyDown("MoveForwardKey", Enum.KeyCode.W) then d += rot.LookVector end
		if MoveKeyDown("MoveBackKey", Enum.KeyCode.S) then d -= rot.LookVector end
		if MoveKeyDown("MoveRightKey", Enum.KeyCode.D) then d += rot.RightVector end
		if MoveKeyDown("MoveLeftKey", Enum.KeyCode.A) then d -= rot.RightVector end
		if MoveKeyDown("MoveUpKey", Enum.KeyCode.Space) then d += Vector3.yAxis end
		if MoveKeyDown("MoveDownKey", Enum.KeyCode.LeftControl) then d -= Vector3.yAxis end
		return d
	end
	function Freecam.Start()
		Freecam.Active = true
		local cf = Camera.CFrame
		local pitch, yaw = cf:ToOrientation()
		Freecam.Pitch, Freecam.Yaw, Freecam.Position = pitch, yaw, cf.Position
		Freecam.PreviousType = Camera.CameraType
		Freecam.PreviousMouse = MenuState.Open and Enum.MouseBehavior.LockCenter or UserInputService.MouseBehavior
		Camera.CameraType = Enum.CameraType.Scriptable
		ContextActionService:BindActionAtPriority("VortexFreecamSink", function() return Enum.ContextActionResult.Sink end, false,
			Enum.ContextActionPriority.High.Value, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftControl, Enum.KeyCode.LeftShift)
	end
	function Freecam.Stop()
		if not Freecam.Active then return end
		Freecam.Active = false
		ContextActionService:UnbindAction("VortexFreecamSink")
		if MenuState.Open then
			CursorSys.Set(true)
		else
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			UserInputService.MouseIconEnabled = true
		end
		Camera.CameraType = Freecam.PreviousType or Enum.CameraType.Custom
	end
	function Freecam.Update(dt)
		if not S.FreecamEnabled then
			if Freecam.Active then Freecam.Stop() end
			return
		end
		if not Freecam.Active then Freecam.Start() end
		if MenuState.Open then
			-- The menu owns pointer state while open; freecam must not lock it per-frame.
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		else
			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				local d = UserInputService:GetMouseDelta()
				Freecam.Yaw -= d.X * 0.0035
				Freecam.Pitch = math.clamp(Freecam.Pitch - d.Y * 0.0035, -1.55, 1.55)
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
		end
		local rot = CFrame.fromOrientation(Freecam.Pitch, Freecam.Yaw, 0)
		local dir = (MenuState.Open or UserInputService:GetFocusedTextBox()) and Vector3.zero or Move.MoveDir(rot)
		local speed = S.FreecamSpeed * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 3 or 1)
		if dir.Magnitude > 0 then dir = dir.Unit end
		Freecam.Position += dir * speed * dt
		Camera.CFrame = CFrame.new(Freecam.Position) * rot
	end

	function AimFn.IsEnemy(player, teamCheck)
		if player == LocalPlayer then return false end
		if teamCheck and player.Team ~= nil and player.Team == LocalPlayer.Team then return false end
		return true
	end
	function AimFn.PartOf(e, name)
		local p = e.Parts[name]
		if p and p.Parent == e.Character then return p end
		p = e.Character and e.Character:FindFirstChild(name) or nil
		e.Parts[name] = p
		return p
	end
	function AimFn.IsVisible(part, character, params)
		local o = Camera.CFrame.Position
		local r = Workspace:Raycast(o, part.Position - o, params)
		return r == nil or r.Instance:IsDescendantOf(character)
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
			Aim.Part, Aim.Position, Aim.Player = AimFn.FindTarget()
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
	function Trig.CollectTriggerParts(e)
		local mode = S.TriggerPart
		if e.TriggerMode == mode and e.TriggerCharacter == e.Character and e.TriggerParts and #e.TriggerParts > 0 then
			return e.TriggerParts
		end
		e.TriggerParts = e.TriggerParts or {}
		table.clear(e.TriggerParts)
		e.TriggerMode, e.TriggerCharacter = mode, e.Character
		if mode == "Head" then
			local h = AimFn.PartOf(e, "Head")
			if h then e.TriggerParts[1] = h end
		elseif mode == "Body" then
			local torso = AimFn.PartOf(e, e.Humanoid.RigType == Enum.HumanoidRigType.R15 and "UpperTorso" or "Torso")
			if torso then e.TriggerParts[#e.TriggerParts + 1] = torso end
			if e.Root and e.Root ~= torso then e.TriggerParts[#e.TriggerParts + 1] = e.Root end
		else
			local names = e.Humanoid.RigType == Enum.HumanoidRigType.R15 and TriggerPartNames.R15 or TriggerPartNames.R6
			for _, n in ipairs(names) do
				local p = AimFn.PartOf(e, n)
				if p then e.TriggerParts[#e.TriggerParts + 1] = p end
			end
		end
		return e.TriggerParts
	end

	local VIM, MouseApiFailed = nil, false
	local LastNoFireMethodLog = 0
	local TriggerRayScratch = {}

	local FireMethodLogged = {}
	local function LogFireOnce(method)
		if FireMethodLogged[method] then return end
		FireMethodLogged[method] = true
		DebugLog.Push("triggerbot", "fire method: " .. method)
	end

	function Trig.ResetTriggerState()
		Trigger.Player, Trigger.Part, Trigger.Target = nil, nil, nil
		Trigger.EnterTime, Trigger.NextFire = nil, 0
	end

	function Trig.FireTrigger()
		if MenuState.Open or UserInputService:GetFocusedTextBox() then return false end
		local now = os.clock()

		-- Tool mode is deterministic for games where firing is driven by Tool:Activate().
		if S.TriggerClickMode == "Tool" then
			local ch = LocalPlayer.Character
			local tool = ch and ch:FindFirstChildOfClass("Tool")
			if tool and tool.Enabled then
				local ok = pcall(function() tool:Activate() end)
				if ok then
					LogFireOnce("Tool:Activate()")
					return true
				end
			end
			if now - LastNoFireMethodLog >= 1 then
				LastNoFireMethodLog = now
				DebugLog.Push("triggerbot", "no fire method available (Tool mode)", true)
			end
			return false
		end

		-- The player is already holding fire: the weapon is firing, do not inject our own press
		-- (our release would cut their hold short).
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return true end

		-- Prefer executor mouse press/release because it behaves like a real held click.
		if type(mouse1press) == "function" and type(mouse1release) == "function" then
			local ok = pcall(mouse1press)
			if ok then
				task.defer(function()
					task.wait(0.01)
					pcall(mouse1release)
				end)
				LogFireOnce("mouse1press/mouse1release")
				return true
			end
		end

		-- Fallback for executors exposing only mouse1click().
		if type(mouse1click) == "function" then
			local ok = pcall(mouse1click)
			if ok then
				LogFireOnce("mouse1click()")
				return true
			end
		end

		-- Last mouse-input fallback. Triggering is done at the actual crosshair center,
		-- not the synthetic cursor position used by the menu/click-TP system.
		if not MouseApiFailed then
			local ok = pcall(function()
				VIM = VIM or game:GetService("VirtualInputManager")
				local vp = Camera.ViewportSize
				local p = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
				VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 0)
				task.defer(function()
					task.wait(0.01)
					pcall(function()
						VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 0)
					end)
				end)
			end)
			if ok then
				LogFireOnce("VirtualInputManager")
				return true
			end
			MouseApiFailed = true
			Core.Notify(Locale.T("TOAST_NOMOUSE"))
			DebugLog.Push("triggerbot", "mouse input unavailable; using Tool fallback")
		end

		local ch = LocalPlayer.Character
		local tool = ch and ch:FindFirstChildOfClass("Tool")
		if tool and tool.Enabled then
			local ok = pcall(function() tool:Activate() end)
			if ok then
				LogFireOnce("Tool fallback")
				return true
			end
		end
		if now - LastNoFireMethodLog >= 1 then
			LastNoFireMethodLog = now
			DebugLog.Push("triggerbot", "no fire method available", true)
		end
		return false
	end

	function Trig.ResolveEntityFromHit(inst)
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


	function Esp.DrawLine(f, a, b, color, th)
		local d = b - a
		f.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
		f.Size = UDim2.fromOffset(d.Magnitude, th or 1.5)
		f.Rotation = math.deg(math.atan2(d.Y, d.X))
		f.BackgroundColor3 = color
		f.Visible = true
	end
	local CornerSegScratch = {} -- reused every call, no per-frame table allocation
	for i = 1, 8 do CornerSegScratch[i] = {0,0,0,0} end
	function Esp.PaintCornerBox(corners, w, h, color)
		local len, th = math.clamp(h * 0.18, 6, 18), 2
		local s = CornerSegScratch
		s[1][1],s[1][2],s[1][3],s[1][4] = 0,0,len,th
		s[2][1],s[2][2],s[2][3],s[2][4] = 0,0,th,len
		s[3][1],s[3][2],s[3][3],s[3][4] = w-len,0,len,th
		s[4][1],s[4][2],s[4][3],s[4][4] = w-th,0,th,len
		s[5][1],s[5][2],s[5][3],s[5][4] = 0,h-th,len,th
		s[6][1],s[6][2],s[6][3],s[6][4] = 0,h-len,th,len
		s[7][1],s[7][2],s[7][3],s[7][4] = w-len,h-th,len,th
		s[8][1],s[8][2],s[8][3],s[8][4] = w-th,h-len,th,len
		for i = 1, 8 do
			local sg, f = s[i], corners[i]
			f.Position, f.Size, f.BackgroundColor3, f.Visible = UDim2.fromOffset(sg[1], sg[2]), UDim2.fromOffset(sg[3], sg[4]), color, true
		end
	end
	-- Fit the box to the character's real body parts. Accessories, tools and loose parts
	-- are ignored, so the box hugs the model instead of the whole model bounding volume.
	-- Body parts are cached per model and refreshed twice a second. Re-walking GetChildren
	-- and building a fresh table for every entity on every frame was a hitch source.
	local BodyPartCache = setmetatable({}, {__mode = "k"})
	local function BodyParts(model)
		local now = os.clock()
		local c = BodyPartCache[model]
		if c and now - c.At < 0.5 then return c.Parts end
		local parts = {}
		if model:FindFirstChildOfClass("Humanoid") then
			for _, part in ipairs(model:GetChildren()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then parts[#parts + 1] = part end
			end
		end
		BodyPartCache[model] = {Parts = parts, At = now}
		return parts
	end

	-- Fit the box to the character's real body parts; accessories, tools and loose parts are
	-- ignored. Non-humanoid models fall back to their bounding volume.
	-- The character's body parts are measured once in root-local space and refreshed every
	-- 0.25s. Per frame only the 8 corners of that box get projected (was ~120 projections
	-- per entity per frame, which was the main FPS cost).
	local function ModelRootCF(model)
		local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or BodyParts(model)[1]
		if root and root.Parent then return root.CFrame end
		local ok, cf = pcall(function() return model:GetBoundingBox() end)
		return ok and cf or nil
	end

	local LocalBoundsCache = setmetatable({}, {__mode = "k"})
	local function LocalBounds(model)
		local now = os.clock()
		local c = LocalBoundsCache[model]
		if c and now - c.At < 0.25 then return c end
		local rcf = ModelRootCF(model)
		if not rcf then return nil end
		local inv = rcf:Inverse()
		local x0, y0, z0, x1, y1, z1 = math.huge, math.huge, math.huge, -math.huge, -math.huge, -math.huge
		local found = false
		local function Grow(cf, hx, hy, hz)
			for ix = -1, 1, 2 do
				for iy = -1, 1, 2 do
					for iz = -1, 1, 2 do
						local p = inv * (cf * Vector3.new(ix * hx, iy * hy, iz * hz))
						if p.X < x0 then x0 = p.X end
						if p.Y < y0 then y0 = p.Y end
						if p.Z < z0 then z0 = p.Z end
						if p.X > x1 then x1 = p.X end
						if p.Y > y1 then y1 = p.Y end
						if p.Z > z1 then z1 = p.Z end
					end
				end
			end
			found = true
		end
		for _, part in ipairs(BodyParts(model)) do
			if part.Parent == model and part.Transparency < 1 then
				local h = part.Size * 0.5
				Grow(part.CFrame, h.X, h.Y, h.Z)
			end
		end
		if not found then
			local ok, cf, size = pcall(function() return model:GetBoundingBox() end)
			if not ok or not cf or not size then return nil end
			Grow(cf, size.X * 0.5, size.Y * 0.5, size.Z * 0.5)
		end
		c = {X0 = x0, Y0 = y0, Z0 = z0, X1 = x1, Y1 = y1, Z1 = z1, At = now}
		LocalBoundsCache[model] = c
		return c
	end

	-- Screen rect of the character: project the cached root-local box with the current root.
	function Esp.ProjectBoundingBox(model)
		if not model or not model:IsA("Model") then return nil end
		local c = LocalBounds(model)
		if not c then return nil end
		local rcf = ModelRootCF(model)
		if not rcf then return nil end
		local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
		for ix = 0, 1 do
			local X = ix == 0 and c.X0 or c.X1
			for iy = 0, 1 do
				local Y = iy == 0 and c.Y0 or c.Y1
				for iz = 0, 1 do
					local Z = iz == 0 and c.Z0 or c.Z1
					local sp = Camera:WorldToViewportPoint(rcf * Vector3.new(X, Y, Z))
					if sp.Z > 0 then
						if sp.X < minX then minX = sp.X end
						if sp.Y < minY then minY = sp.Y end
						if sp.X > maxX then maxX = sp.X end
						if sp.Y > maxY then maxY = sp.Y end
					end
				end
			end
		end
		if minX == math.huge then return nil end
		return minX, minY, maxX, maxY
	end

	function Esp.AttachViewportBox(e, root, left, top, width, height, centerX, centerY)
		-- All ESP geometry is positioned in ScreenGui pixels. Avoid BillboardGui world-offset
		-- estimation, which drifts as FOV, distance, camera angle, or model scale changes.
		if not e or not e.Folder then return end
		e.Folder.Position = UDim2.fromOffset(left, top)
		e.Folder.Size = UDim2.fromOffset(math.max(1, width), math.max(1, height))
		e.Folder.Visible = true
		e.Box.Position = UDim2.fromOffset(0, 0)
		e.Box.Size = UDim2.fromOffset(math.max(1, width), math.max(1, height))
		return left, top
	end
	local NextBotId = 0
	local BotByHumanoid, BotByRoot, BotByModel = {}, {}, {}

	function Esp.IsUnderPlayerCharacter(model)
		if not model then return false end
		local cur = model
		for _ = 1, 16 do
			if not cur or cur == Workspace then break end
			if cur:IsA("Model") and Players:GetPlayerFromCharacter(cur) then return true end
			cur = cur.Parent
		end
		return false
	end

	function Esp.IsBotModel(model)
		if not model or not model:IsA("Model") or not model:IsDescendantOf(Workspace) then return false end
		if Esp.IsUnderPlayerCharacter(model) then return false end
		local hum = model:FindFirstChildOfClass("Humanoid")
		if not hum then return false end
		return (hum.RootPart or model:FindFirstChild("HumanoidRootPart", true)) ~= nil
	end

	function Esp.GetBotParts(model)
		local hum = model and model:FindFirstChildOfClass("Humanoid")
		local root = hum and (hum.RootPart or model:FindFirstChild("HumanoidRootPart", true))
		return hum, root
	end

	function Esp.CanonicalBotModel(model)
		if not Esp.IsBotModel(model) then return nil end
		local hum, root = Esp.GetBotParts(model)
		if not hum or not root then return nil end
		local canonical = model
		local parent = model.Parent
		while parent and parent:IsA("Model") do
			local ph = parent:FindFirstChildOfClass("Humanoid")
			local pr = ph and (ph.RootPart or parent:FindFirstChild("HumanoidRootPart", true))
			if ph == hum or pr == root then
				canonical = parent
			else
				break
			end
			parent = parent.Parent
		end
		return canonical
	end

	function Esp.FindModelRoot(model)
		if not model or not model:IsA("Model") then return nil end
		local preferred = {"HumanoidRootPart","RootPart","Root","PrimaryPart","Head","UpperTorso","Torso","LowerTorso"}
		for _, name in ipairs(preferred) do
			local p = (name == "PrimaryPart" and model.PrimaryPart) or model:FindFirstChild(name, true)
			if p and p:IsA("BasePart") then return p end
		end
		local best, bestVolume = nil, -1
		local seen = 0
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				seen += 1
				if seen > 64 then break end
				local v = d.Size.X * d.Size.Y * d.Size.Z
				if v > bestVolume then best, bestVolume = d, v end
			end
		end
		return best
	end

	function Esp.ShouldRegisterGenericModel(model)
		if not model or not model:IsA("Model") or not model:IsDescendantOf(Workspace) then return false end
		if Esp.IsUnderPlayerCharacter(model) then return false end
		if model:GetAttribute("NoVortexESP") == true then return false end
		local tagged = false
		pcall(function()
			tagged = model:GetAttribute("ESP") == true or model:GetAttribute("Bot") == true or model:GetAttribute("IsBot") == true or model:GetAttribute("NPC") == true
			if not tagged then
				for _, tag in ipairs(game:GetService("CollectionService"):GetTags(model)) do
					local t = string.lower(tostring(tag))
					if t == "bot" or t == "npc" or t == "enemy" or t == "esp" or t == "ai" then tagged = true break end
				end
			end
		end)
		-- Cheap root probe: avoid scanning all descendants for every nested ModelAdded event.
		local root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart", true) or model:FindFirstChildWhichIsA("BasePart", true)
		if not root then return false end
		if tagged then return true end
		-- Unmarked weapon/item/loot models are not entity ESP candidates. Split CamelCase
		-- and separators into tokens to avoid substring false positives such as "GunfightMap".
		local tokenName = tostring(model.Name or ""):gsub("([a-z])([A-Z])", "%1 %2"):lower():gsub("[^%w]+", " ")
		local excludedTokens = {weapon=true, gun=true, rifle=true, pistol=true, smg=true, shotgun=true, sniper=true, bow=true, crossbow=true,
			blade=true, sword=true, knife=true, katana=true, revolver=true, launcher=true, blaster=true, laser=true, spear=true, staff=true, wand=true,
			item=true, pickup=true, collectible=true, loot=true, drop=true, crate=true, chest=true, ammo=true, med=true, health=true, armor=true,
			armour=true, coin=true, cash=true, key=true, token=true, gem=true, orb=true, battery=true}
		for token in tokenName:gmatch("%w+") do if excludedTokens[token] then return false end end
		local entityHints = {bot=true, npc=true, dummy=true, enemy=true, ai=true, target=true, zombie=true, monster=true, creature=true, alien=true, soldier=true, guard=true, humanoid=true, mutant=true, mob=true, boss=true, agent=true}
		local hasEntityHint = false
		for token in tokenName:gmatch("%w+") do if entityHints[token] then hasEntityHint = true; break end end
		if not hasEntityHint then return false end
		-- Entity-name hints alone plus a real BasePart are the fallback for untagged rigs.
		-- Avoid a full GetDescendants scan here; explicit tags/attributes remain authoritative.
		if model:FindFirstChildWhichIsA("Tool", true) and not model:FindFirstChildOfClass("Humanoid") then return false end
		return true
	end

	do
		local ok, err = pcall(function()
			local dummy = Instance.new("Model")
			dummy.Name = "VortexSelfTestDummy"
			local hum = Instance.new("Humanoid", dummy)
			local root = Instance.new("Part", dummy)
			root.Name = "HumanoidRootPart"
			Esp.IsUnderPlayerCharacter(dummy)
			Esp.IsBotModel(dummy)
			Esp.GetBotParts(dummy)
			Esp.CanonicalBotModel(dummy)
			dummy:Destroy()
		end)
		if not ok then DebugLog.Push("selftest", "bot-identity self-test failed: " .. tostring(err), true) end
	end

	function Esp.NewEntry(entity, isBot)
		if not entity then return nil end
		local existing = Entries[entity]
		if existing then return existing end
		if isBot then NextBotId += 1 end
		local folderName = isBot and ("ESP_BOT_" .. tostring(NextBotId)) or ("ESP_" .. tostring(entity.UserId or entity.Name or NextBotId))
		-- Per-entry full-screen canvas for tracers/arrows; the target box itself is a pixel-positioned child.
		local screenFolder = New("Frame", ESPOverlay, {Name = folderName .. "_Screen", Position = UDim2.fromOffset(0,0), Size = UDim2.fromScale(1,1),
			BackgroundTransparency = 1, BorderSizePixel = 0, Visible = true, Active = false, ZIndex = 1})
		local attached = nil -- retained as a compatibility field; boxes no longer use BillboardGui.
		local folder = New("Frame", screenFolder, {Name = "Container", Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(120,180),
			BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 2})
		local e = {
			Folder = folder, ScreenFolder = screenFolder, Attached = attached, Shown = false, Bones = {}, Parts = {}, TriggerParts = {}, TriggerMode = nil,
			TriggerCharacter = nil, LastToolCheck = 0, Entity = entity, IsBot = isBot == true,
			IsGeneric = isBot == true and entity:IsA("Model") and entity:FindFirstChildOfClass("Humanoid") == nil
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
		e.Arrow = New("Frame", screenFolder, {AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.fromOffset(12,12), Rotation = 45, BorderSizePixel = 0, Visible = false, ZIndex = 4})
		e.Tracer = New("Frame", screenFolder, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, Visible = false, ZIndex = 1})
		for _ = 1, 14 do
			table.insert(e.Bones, New("Frame", folder, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, Visible = false, ZIndex = 2}))
		end
		function e.Refresh()
			local target = e.Entity
			local ch = e.IsBot and target or (target and target.Character)
			if e.IsGeneric then
				e.Character = ch
				e.Humanoid = ch and ch:FindFirstChildOfClass("Humanoid") or nil
				if not ch or not ch.Parent then e.Root = nil; return false end
				-- Keep a valid root between frames; only search descendants after it becomes invalid.
				if not e.Root or not e.Root.Parent or not e.Root:IsDescendantOf(ch) then e.Root = Esp.FindModelRoot(ch) end
				if not e.Root or not e.Root.Parent or not e.Root:IsDescendantOf(ch) then return false end
				return true
			end
			local hum, root = e.Humanoid, e.Root
			if e.Character ~= ch or not hum or not root or hum.Parent ~= ch or not root:IsDescendantOf(ch) then
				table.clear(e.Parts)
				e.Character, e.Humanoid, e.Root, e.Tool, e.ChamColor, e.TriggerMode, e.TriggerCharacter = ch, nil, nil, nil, nil, nil, nil
				table.clear(e.TriggerParts)
				if not ch then return false end
				hum = ch:FindFirstChildOfClass("Humanoid")
				root = hum and (hum.RootPart or ch:FindFirstChild("HumanoidRootPart"))
				if not root then root = Esp.FindModelRoot(ch) end
				if not hum or not root then return false end
				e.Humanoid, e.Root = hum, root
			end
			return hum.Health > 0 and ch.Parent ~= nil and root.Parent ~= nil and root:IsDescendantOf(ch)
		end
		Entries[entity] = e
		EntryIndex[entity] = #EntryOrder + 1
		EntryOrder[#EntryOrder + 1] = entity
		return e
	end
	function Esp.NewPlayerEntry(player) return Esp.NewEntry(player, false) end
	function Esp.NewBotEntry(model) return Esp.NewEntry(model, true) end

	function Esp.RemoveEntry(entity)
		local e = Entries[entity]
		if not e then return end
		if e.IsBot then
			if e.Humanoid and BotByHumanoid[e.Humanoid] == e then BotByHumanoid[e.Humanoid] = nil end
			if e.Root and BotByRoot[e.Root] == e then BotByRoot[e.Root] = nil end
			if e.Entity and BotByModel[e.Entity] == e then BotByModel[e.Entity] = nil end
		end
		if e.Cham then pcall(function() e.Cham:Destroy() end); e.Cham = nil end
		if e.Attached then pcall(function() if e.Attached.Parent then e.Attached:Destroy() end end) end
		if e.ScreenFolder then pcall(function() if e.ScreenFolder.Parent then e.ScreenFolder:Destroy() end end) end
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
	function Esp.HideEntry(e)
		e.Shown = false
		if e.Folder then e.Folder.Visible = false end
		if e.Attached then e.Attached.Enabled = false end
		e.Box.Visible, e.NameLabel.Visible, e.Info.Visible, e.HealthBack.Visible, e.Dot.Visible, e.Arrow.Visible, e.Tracer.Visible = false, false, false, false, false, false, false
		if e.Corners then for _, f in ipairs(e.Corners) do f.Visible = false end end
		for _, b in ipairs(e.Bones) do b.Visible = false end
	end
	-- Nearest body part to the crosshair, refreshed 10x/s per entity.
	local function LimbFor(e, ch)
		local now = os.clock()
		if e.LimbAt and now - e.LimbAt < 0.1 then return e.LimbName end
		e.LimbAt = now
		local best, bestD = nil, math.huge
		local cx, cy = Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5
		for _, part in ipairs(BodyParts(ch)) do
			if part.Parent == ch and part.Transparency < 1 then
				local sp = Camera:WorldToViewportPoint(part.Position)
				if sp.Z > 0 then
					local d = (sp.X - cx) ^ 2 + (sp.Y - cy) ^ 2
					if d < bestD then bestD, best = d, part.Name end
				end
			end
		end
		e.LimbName = best and (string.gsub(best, "(%l)(%u)", "%1 %2")) or nil
		return e.LimbName
	end

	local function SkelPoint(e, name, cache, ox, oy)
		local v = cache[name]
		if v == nil then
			local p = AimFn.PartOf(e, name)
			v = false
			if p then
				local sc = Camera:WorldToViewportPoint(p.Position)
				if sc.Z > 0 then v = Vector2.new(sc.X - ox, sc.Y - oy) end
			end
			cache[name] = v
		end
		return v or nil
	end

	function Esp.UpdateEntry(entity, e, heavy)
		if not e or Entries[entity] ~= e or not e.Folder or not e.Folder.Parent then return end
		if e.IsBot and Esp.IsUnderPlayerCharacter(e.Entity) then
			Esp.HideEntry(e)
			return
		end
		if not S.ESPEnabled then Esp.HideEntry(e); return end
		-- Refresh first so Respawn/Character swaps are resolved before team/target checks.
		if not e.Refresh() then Esp.HideEntry(e); return end
		if not Esp.EntryVisible(entity, e) then Esp.HideEntry(e); return end
		local ch, hum, root = e.Character, e.Humanoid, e.Root
		if not ch or not hum or not root or not ch.Parent or not root.Parent then Esp.HideEntry(e); return end
		local dist = (root.Position - Camera.CFrame.Position).Magnitude
		if dist > S.ESPMaxDistance then Esp.HideEntry(e); return end
		local color = ESPColors[S.ESPColor] or ESPColors.Red
		if Aim.Player == entity then color = Theme.Accent end
		local rs = Camera:WorldToViewportPoint(root.Position)
		local minX, minY, maxX, maxY = Esp.ProjectBoundingBox(ch)
		if rs.Z <= 0 or minX == nil then
			Esp.HideEntry(e)
			if S.ShowOffscreen then
				local vp = Camera.ViewportSize
				local rel = Camera.CFrame:PointToObjectSpace(root.Position)
				local dir = Vector2.new(rel.X, -rel.Y)
				if rel.Z > 0 then dir = -dir end
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
		local topY = minY
		local h = math.max(math.abs(maxY - minY), 10)
		local w = math.max(math.abs(maxX - minX), 8)
		local x = (minX + maxX) * 0.5
		local boxLeft = minX
		local boxCenterY = (minY + maxY) * 0.5
		Esp.AttachViewportBox(e, root, boxLeft, topY, w, h, x, boxCenterY)
		if S.ShowBoxes then
			e.Box.Position = UDim2.fromOffset(0, 0)
			e.Box.Size = UDim2.fromOffset(w, h)
			e.BoxStroke.Color = color
			e.BoxStroke.Thickness = 1.5
			e.BoxStroke.Transparency = S.CornerBoxEnabled and 1 or 0
			-- The corner segments are children of e.Box, so the parent must stay visible.
			e.Box.Visible = true
			if S.CornerBoxEnabled then
				if not e.Corners then
					e.Corners = {}
					for _ = 1, 8 do table.insert(e.Corners, New("Frame", e.Box, {BorderSizePixel = 0, ZIndex = 2})) end
				end
				Esp.PaintCornerBox(e.Corners, w, h, color)
			elseif e.Corners then
				for _, f in ipairs(e.Corners) do f.Visible = false end
			end
		else
			e.Box.Visible = false
		end
		if S.ShowTracers then
			local vp = Camera.ViewportSize
			local o = S.TracerOrigin == "Top" and Vector2.new(vp.X / 2, 0) or (S.TracerOrigin == "Center" and Vector2.new(vp.X / 2, vp.Y / 2) or Vector2.new(vp.X / 2, vp.Y))
			Esp.DrawLine(e.Tracer, o, Vector2.new(x, topY + h), color, 1)
		else
			e.Tracer.Visible = false
		end
		if e.IsBot then
			e.NameLabel.Position = UDim2.fromOffset(w * 0.5, -5)
			e.NameLabel.Text = Locale.T("BOT_LABEL")
			e.NameLabel.TextColor3 = color
			e.NameLabel.Visible = true
		elseif S.ShowNames then
			e.NameLabel.Position = UDim2.fromOffset(w * 0.5, -5)
			e.NameLabel.Text = entity.Name
			e.NameLabel.TextColor3 = Color3.new(1,1,1)
			e.NameLabel.Visible = true
		else
			e.NameLabel.Visible = false
		end
		local lines = Esp.Lines or {}
		Esp.Lines = lines
		table.clear(lines)
		if S.ShowDistance then table.insert(lines, math.floor(dist) .. " m") end
		if S.ShowLimb then local limb = LimbFor(e, ch); if limb then table.insert(lines, limb) end end
		if S.ShowWeapon then
			local now = os.clock()
			if now - (e.LastToolCheck or 0) >= 0.12 or e.Tool == nil or e.Tool.Parent ~= ch then
				e.LastToolCheck = now
				e.Tool = ch:FindFirstChildOfClass("Tool")
			end
			table.insert(lines, e.Tool and e.Tool.Name or "None")
		end
		if S.ESPHealthPercent then
			local maxHealth = hum.MaxHealth > 0 and hum.MaxHealth or 100
			local ratio = math.clamp(hum.Health / maxHealth, 0, 1)
			table.insert(lines, string.format("%d%%", math.floor(ratio * 100 + 0.5)))
		end
		if #lines > 0 then
			e.Info.Position = UDim2.fromOffset(w * 0.5, h + 2)
			e.Info.Size = UDim2.fromOffset(200, math.max(14, #lines * 14))
			local txt = table.concat(lines, "\n")
			if e.Info.Text ~= txt then e.Info.Text = txt end
			e.Info.Visible = true
		else
			e.Info.Text = ""
			e.Info.Visible = false
		end
		if S.ShowHealth then
			local mh = hum.MaxHealth > 0 and hum.MaxHealth or 100
			local pc = math.clamp(hum.Health / mh, 0, 1)
			e.HealthBack.Position = UDim2.fromOffset(-6, 0)
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
			if ho then e.Dot.Position = UDim2.fromOffset(hs.X - boxLeft, hs.Y - topY); e.Dot.BackgroundColor3 = color end
		else
			e.Dot.Visible = false
		end
		if S.ShowSkeleton then
			local bones = hum.RigType == Enum.HumanoidRigType.R15 and R15Bones or R6Bones
			local proj = e.SkelProj or {}
			e.SkelProj = proj
			table.clear(proj)
			for i, line in ipairs(e.Bones) do
				local vis, pair = false, bones[i]
				if pair then
					local pa = SkelPoint(e, pair[1], proj, boxLeft, topY)
					local pb = pa and SkelPoint(e, pair[2], proj, boxLeft, topY)
					if pa and pb then
						Esp.DrawLine(line, pa, pb, color, 1.5)
						vis = true
					end
				end
				line.Visible = vis
			end
		elseif not S.ShowSkeleton then
			for _, line in ipairs(e.Bones) do line.Visible = false end
		end
		e.Arrow.Visible = false
	end
	function Esp.UpdateGenericEntry(entity, e, heavy)
		if not e or not e.IsGeneric or not e.Folder or not e.Folder.Parent then return end
		-- Classification-specific switches are applied by the public Esp.UpdateEntry wrapper.
		if not S.ESPEnabled then Esp.HideEntry(e); return end
		if not e.Refresh() then Esp.HideEntry(e); return end
		local model, root = e.Character, e.Root
		if not model or not root then Esp.HideEntry(e); return end
		local dist = (root.Position - Camera.CFrame.Position).Magnitude
		if dist > (tonumber(S.ESPMaxDistance) or 1500) then Esp.HideEntry(e); return end
		local color = ESPColors[S.ESPColor] or ESPColors.Red
		if S.ESPRainbow then color = Color3.fromHSV((os.clock() * math.max(0.01, S.ESPRainbowSpeed or 0.2)) % 1, 0.85, 1) end
		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local now = os.clock()
		local minX, minY, maxX, maxY = Esp.ProjectBoundingBox(model)
		local front = minX ~= nil
		if not front then
			Esp.HideEntry(e)
			if S.ShowOffscreen then
				local rel=Camera.CFrame:PointToObjectSpace(root.Position); local dir=Vector2.new(rel.X,-rel.Y); if rel.Z>0 then dir=-dir end; dir=dir.Magnitude<0.001 and Vector2.new(0,-1) or dir.Unit
				local pt=center+dir*(math.min(vp.X,vp.Y)*0.42); e.Arrow.Position=UDim2.fromOffset(pt.X,pt.Y); e.Arrow.BackgroundColor3=color; e.Arrow.Visible=true; e.Shown=true
			end
			return
		end
		local w,h=math.max(maxX-minX,8),math.max(maxY-minY,10); e.Shown=true
		local centerX, centerY = (minX + maxX) * 0.5, (minY + maxY) * 0.5
		Esp.AttachViewportBox(e, root, minX, minY, w, h, centerX, centerY)
		if S.ShowBoxes then
			e.Box.Position=UDim2.fromOffset(0,0); e.Box.Size=UDim2.fromOffset(w,h); e.BoxStroke.Color=color; e.BoxStroke.Thickness=1.5; e.BoxStroke.Transparency=S.CornerBoxEnabled and 1 or 0; e.Box.Visible=true
			if S.CornerBoxEnabled then
				if not e.Corners then e.Corners={}; for _=1,8 do table.insert(e.Corners,New("Frame",e.Box,{BorderSizePixel=0,ZIndex=2})) end end
				Esp.PaintCornerBox(e.Corners, w, h, color)
			end
		else e.Box.Visible=false; if e.Corners then for _,f in ipairs(e.Corners) do f.Visible=false end end end
		if S.ShowNames then e.NameLabel.Position=UDim2.fromOffset(w*0.5,-5); e.NameLabel.Text=model.Name; e.NameLabel.TextColor3=color; e.NameLabel.Visible=true else e.NameLabel.Visible=false end
		if S.ShowDistance then e.Info.Position=UDim2.fromOffset(w*0.5,h+2); e.Info.Text=string.format("%.0f m",dist); e.Info.Visible=true else e.Info.Visible=false end
		if S.ShowTracers then local origin=S.TracerOrigin=="Top" and Vector2.new(vp.X/2,0) or (S.TracerOrigin=="Center" and center or Vector2.new(vp.X/2,vp.Y)); Esp.DrawLine(e.Tracer,origin,Vector2.new((minX+maxX)*0.5,maxY),color,1) else e.Tracer.Visible=false end
		e.HealthBack.Visible=false; e.Dot.Visible=false; e.Arrow.Visible=false; for _,line in ipairs(e.Bones) do line.Visible=false end
	end

	function Esp.UpdateCham(entity, e)
		local ch = e.Character or (e.IsBot and e.Entity or entity.Character)
		if S.ESPEnabled and S.ChamsEnabled and ch ~= nil and e.Shown then
			if not e.Cham or e.Cham.Parent ~= ch then
				if e.Cham then e.Cham:Destroy() end
				e.Cham = New("Highlight", ch, {Name = "VortexCham", DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, FillTransparency = 0.6, OutlineTransparency = 0})
				e.ChamColor = nil
			end
			local color = Aim.Player == entity and Theme.Accent or (ESPColors[S.ESPColor] or ESPColors.Red)
			local kind = e.Kind or (e.IsBot and AdvClassifyEntry(e) or "Player")
			if S.ESPTeamColors and kind == "Player" and typeof(entity) == "Instance" and entity:IsA("Player") and entity.Team then
				color = entity.Team.TeamColor.Color
			end
			if e.ChamColor ~= color then e.Cham.FillColor, e.Cham.OutlineColor, e.ChamColor = color, color, color end
		elseif e.Cham then
			e.Cham:Destroy(); e.Cham, e.ChamColor = nil, nil
		end
	end

	local CachedChar, CachedHum
	function Core.GetHumanoid()
		local ch = LocalPlayer.Character
		if not ch then CachedChar, CachedHum = nil, nil; return nil end
		if ch ~= CachedChar or not CachedHum or CachedHum.Parent ~= ch then
			CachedChar, CachedHum = ch, ch:FindFirstChildOfClass("Humanoid")
		end
		return CachedHum
	end
	function Esp.UpdateMovement()
		local hum = Core.GetHumanoid()
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
			local hum = Core.GetHumanoid()
			if hum then hum.PlatformStand = false end
		end
	end
	function Fly.Update()
		if not S.FlyEnabled then
			if Fly.Active then Fly.Stop() end
			return
		end
		local hum = Core.GetHumanoid()
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
		local dir = (UserInputService:GetFocusedTextBox() or Freecam.Active) and Vector3.zero or Move.MoveDir(look)
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
	function Scene.FlashLightning()
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
	function Scene.Ovr(id, on, save, apply, restore)
		local e = Saved[id]
		if on then
			if not e then e = {v = save(), r = restore}; Saved[id] = e end
			apply()
		elseif e then
			Saved[id] = nil
			restore(e.v)
		end
	end

	-- crez_ovr_v2: old World.Update built 3 new closures per Ovr() call, 10 calls/frame = 30 closure
	-- allocations every single frame regardless of whether any override was active. Pre-declaring the
	-- save/apply/restore functions once (below, outside the per-frame loop) drops that to zero per-frame
	-- allocation — Ovr() itself already only touches the Saved table on actual state transitions.
	function Scene.FogSave() return {Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor} end
	function Scene.FogApply()
		if S.FogEnabled then Lighting.FogStart = 0; Lighting.FogEnd = S.FogDensity; Lighting.FogColor = Core.TintColor(S.FogColorName)
		else Lighting.FogEnd = 1e6 end
	end
	function Scene.FogRestore(v) Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = v[1], v[2], v[3] end

	function Scene.AtmoSave() local a = AtmosphereObject; return {a.Density, a.Offset, a.Color, a.Decay, a.Glare, a.Haze} end
	function Scene.AtmoApply()
		local col = Core.TintColor(S.AtmoColorName)
		local a = AtmosphereObject
		a.Density, a.Haze, a.Color, a.Decay, a.Glare, a.Offset = S.AtmoDensity, S.AtmoHaze, col, col, 0.3, 0.25
	end
	function Scene.AtmoRestore(v) local a = AtmosphereObject; a.Density, a.Offset, a.Color, a.Decay, a.Glare, a.Haze = v[1], v[2], v[3], v[4], v[5], v[6] end

	function Scene.ClockSave() return {Lighting.ClockTime} end
	local ClockApplyDt = 0
	function Scene.ClockApply()
		if S.TimeFlowEnabled then
			World.Flow = ((World.Flow or (S.TimeOfDayEnabled and S.TimeOfDay or Lighting.ClockTime)) + S.TimeFlowSpeed * ClockApplyDt) % 24
			Lighting.ClockTime = World.Flow
		elseif S.TimeOfDayEnabled then
			World.Flow = nil; Lighting.ClockTime = S.TimeOfDay
		else
			-- No time override is active: preserve the world's current clock rather than forcing 14:00.
			World.Flow = nil
		end
	end
	function Scene.ClockRestore(v) World.Flow = nil; Lighting.ClockTime = v[1] end

	function Scene.ShadowsSave() return {Lighting.GlobalShadows} end
	function Scene.ShadowsApply() Lighting.GlobalShadows = false end
	function Scene.ShadowsRestore(v) Lighting.GlobalShadows = v[1] end

	function Scene.AmbSave() return {Lighting.Brightness, Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom} end
	function Scene.AmbApply()
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
			local col = Core.TintColor(S.AmbientColorName)
			local mixed = col:Lerp(Color3.fromRGB(128,128,128), 1 - S.AmbientIntensity)
			Lighting.Ambient, Lighting.OutdoorAmbient = mixed, mixed
		end
	end
	function Scene.AmbRestore(v)
		Lighting.Brightness, Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ColorShift_Top, Lighting.ColorShift_Bottom = v[1], v[2], v[3], v[4], v[5]
	end

	function Scene.StarsSave() return {Lighting.StarCount} end
	function Scene.StarsApply() Lighting.StarCount = S.StarCount end
	function Scene.StarsRestore(v) Lighting.StarCount = v[1] end

	function Scene.ExposureSave() return {Lighting.ExposureCompensation} end
	function Scene.ExposureApply() Lighting.ExposureCompensation = S.Exposure end
	function Scene.ExposureRestore(v) Lighting.ExposureCompensation = v[1] end

	function Scene.CloudsSave() return {Clouds.Enabled} end
	function Scene.CloudsApply() Clouds.Enabled = false end
	function Scene.CloudsRestore(v) Clouds.Enabled = v[1] end

	function Scene.GravitySave() return {Workspace.Gravity} end
	function Scene.GravityApply() Workspace.Gravity = S.GravityValue end
	function Scene.GravityRestore(v) Workspace.Gravity = v[1] end

	function Scene.ZoomLimitSave() return {LocalPlayer.CameraMaxZoomDistance} end
	function Scene.ZoomLimitApply() LocalPlayer.CameraMaxZoomDistance = S.ZoomLimit end
	function Scene.ZoomLimitRestore(v) LocalPlayer.CameraMaxZoomDistance = v[1] end

	function World.Update(dt)
		ClockApplyDt = dt
		WeatherPart.CFrame = CFrame.new(Camera.CFrame.Position + Vector3.new(0, 35, 0))
		SnowEmitter.Rate = S.SnowEnabled and S.SnowIntensity * 3 or 0
		RainEmitter.Rate = S.RainEnabled and S.RainIntensity * 6 or 0
		AshEmitter.Rate = S.AshEnabled and S.AshIntensity or 0
		SnowEmitter.Acceleration = Vector3.new(S.WindStrength, -2, S.WindStrength * 0.4)
		RainEmitter.Acceleration = Vector3.new(S.WindStrength * 2, -30, S.WindStrength * 0.6)
		AshEmitter.Acceleration = Vector3.new(S.WindStrength * 0.5, -1, S.WindStrength * 0.25)

		Scene.Ovr("fog", S.FogEnabled or S.FullBrightEnabled, Scene.FogSave, Scene.FogApply, Scene.FogRestore)

		FX.Flash.Enabled = S.LightningEnabled
		if S.LightningEnabled and os.clock() >= World.NextFlash then
			World.NextFlash = os.clock() + S.LightningInterval * (0.5 + math.random())
			Scene.FlashLightning()
		end
		FX.Bloom.Enabled = S.GlowEnabled
		FX.Bloom.Intensity = S.GlowIntensity * 3
		FX.Bloom.Size = S.GlowSize
		FX.Grade.Enabled = S.ColorGradeEnabled
		if S.ColorGradeEnabled then
			FX.Grade.Saturation = S.ColorSaturation
			FX.Grade.Contrast = S.ColorContrast
			FX.Grade.Brightness = S.ColorBrightness
			FX.Grade.TintColor = Core.TintColor(S.ColorTintName)
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

		Scene.Ovr("atmo", S.AtmosphereEnabled, Scene.AtmoSave, Scene.AtmoApply, Scene.AtmoRestore)
		Scene.Ovr("clock", S.TimeOfDayEnabled or S.TimeFlowEnabled, Scene.ClockSave, Scene.ClockApply, Scene.ClockRestore)
		Scene.Ovr("shadows", S.NoShadowsEnabled or S.FullBrightEnabled, Scene.ShadowsSave, Scene.ShadowsApply, Scene.ShadowsRestore)
		Scene.Ovr("amb", S.FullBrightEnabled or S.RainbowEnabled or S.AmbientEnabled, Scene.AmbSave, Scene.AmbApply, Scene.AmbRestore)
		Scene.Ovr("stars", S.StarsEnabled, Scene.StarsSave, Scene.StarsApply, Scene.StarsRestore)
		Scene.Ovr("exposure", S.ExposureEnabled, Scene.ExposureSave, Scene.ExposureApply, Scene.ExposureRestore)
		if Clouds then
			Scene.Ovr("clouds", S.HideCloudsEnabled, Scene.CloudsSave, Scene.CloudsApply, Scene.CloudsRestore)
		end
		Scene.Ovr("gravity", S.GravityEnabled, Scene.GravitySave, Scene.GravityApply, Scene.GravityRestore)
		Scene.Ovr("zoomlimit", S.ZoomLimitEnabled, Scene.ZoomLimitSave, Scene.ZoomLimitApply, Scene.ZoomLimitRestore)

		if not Freecam.Active then
			local held = Core.ZoomHeld and Core.ZoomHeld() or false
			local desired = held and S.ZoomFOV or (S.CustomFOVEnabled and S.CameraFOV) or nil
			local a = 1 - math.exp(-math.max(0.1, tonumber(S.FOVTransitionSpeed) or 16) * dt)
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
		if World.FovOn and Camera then pcall(function() Camera.FieldOfView = World.FovBase end); World.FovOn = false end
		if AtmosphereOwned then pcall(function() AtmosphereObject:Destroy() end); AtmosphereOwned = false end
		for _, fx in pairs(FX) do pcall(function() fx:Destroy() end) end
		pcall(function() if WeatherPart then WeatherPart:Destroy() end end)
	end

	local FovFrame = Round(New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(300,300),
		BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false}), 100)
	New("UIStroke", FovFrame, {Color = "@Accent", Thickness = 1.5, Transparency = 0.35})
	local TriggerFovFrame = Round(New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(10,10),
		BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false}), 100)
	local TriggerFovStroke = New("UIStroke", TriggerFovFrame, {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.1})
	local TargetLine = New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, BackgroundColor3 = "@Accent", BackgroundTransparency = 0.2, Visible = false})
	local Cross = {Extra = 0, Sig = "", Gap = -1, Col = nil}
	Cross.Holder = New("Frame", Overlay, {Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(0,0), BackgroundTransparency = 1, Visible = false, ZIndex = 7})
	Cross.DotOutline = New("Frame", Cross.Holder, {AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, ZIndex = 6})
	Cross.Dot = New("Frame", Cross.Holder, {AnchorPoint = Vector2.new(0.5,0.5), BorderSizePixel = 0, ZIndex = 7})
	local ArmAnchors = {Vector2.new(0.5,1), Vector2.new(0.5,0), Vector2.new(1,0.5), Vector2.new(0,0.5)} -- top, bottom, left, right
	Cross.Arms = {}
	for i = 1, 4 do
		local outline = New("Frame", Cross.Holder, {AnchorPoint = ArmAnchors[i], BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, ZIndex = 6})
		local arm = New("Frame", Cross.Holder, {AnchorPoint = ArmAnchors[i], BorderSizePixel = 0, ZIndex = 7})
		Cross.Arms[i] = {arm, outline}
	end
	local function CrossLayout(gap, len, th, dot, outlineOn)
		local o = outlineOn and 1 or 0
		local pos = {UDim2.fromOffset(0, -gap), UDim2.fromOffset(0, gap), UDim2.fromOffset(-gap, 0), UDim2.fromOffset(gap, 0)}
		local vertical = {true, true, false, false}
		for i = 1, 4 do
			local arm, outline = Cross.Arms[i][1], Cross.Arms[i][2]
			local size = vertical[i] and UDim2.fromOffset(th, len) or UDim2.fromOffset(len, th)
			arm.Position, arm.Size = pos[i], size
			outline.Position, outline.Size, outline.Visible = pos[i], size + UDim2.fromOffset(2*o, 2*o), outlineOn
		end
		Cross.Dot.Size = UDim2.fromOffset(dot, dot)
		Cross.Dot.Visible = S.CrosshairDot == true
		Cross.DotOutline.Size = UDim2.fromOffset(dot + 2*o, dot + 2*o)
		Cross.DotOutline.Visible = S.CrosshairDot == true and outlineOn
	end

	function Core.GetPing()
		local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
		return ok and math.floor(v) or 0
	end
	function FxFn.UpdateCrosshair(dt)
		Cross.Holder.Visible = S.CrosshairEnabled
		if not S.CrosshairEnabled then return end
		local hum = Core.GetHumanoid()
		local moving = hum ~= nil and hum.MoveDirection.Magnitude > 0.1
		local target = (S.CrosshairDynamic and moving) and 5 or 0
		Cross.Extra += (target - Cross.Extra) * (1 - math.exp(-12 * dt))
		local gap = math.floor((S.CrosshairGap or 0) + (S.CrosshairDynamic and Cross.Extra or 0) + 0.5)
		local len = math.max(1, math.floor(S.CrosshairSize or 6))
		local th = math.max(1, math.floor(S.CrosshairThickness or 2))
		local outlineOn = S.CrosshairOutline == true
		local sig = len .. "|" .. th .. "|" .. (outlineOn and 1 or 0) .. "|" .. (S.CrosshairDot and 1 or 0)
		if sig ~= Cross.Sig or gap ~= Cross.Gap then
			CrossLayout(gap, len, th, th + 1, outlineOn)
			Cross.Sig, Cross.Gap = sig, gap
		end
		local color
		if S.CrosshairReactive and (Trigger.Player or Aim.Player) then color = ESPColors.Red
		elseif S.CrosshairColorName == "Theme" then color = Theme.Accent
		else color = ESPColors[S.CrosshairColorName] or ESPColors.White end
		if color ~= Cross.Col then
			Cross.Col = color
			Cross.Dot.BackgroundColor3 = color
			for i = 1, 4 do Cross.Arms[i][1].BackgroundColor3 = color end
		end
		if S.CrosshairSpin then
			Cross.Holder.Rotation = (Cross.Holder.Rotation + 120 * dt) % 360
		elseif Cross.Holder.Rotation ~= 0 then
			Cross.Holder.Rotation = 0
		end
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

	function FxFn.HitHideAll()
		Hit.Ring.Visible = false
		Hit.RingStroke.Transparency = 1
		Hit.Text.Visible = false
		for _, line in ipairs(Hit.Lines) do line.Visible = false end
		for _, f in ipairs(Hit.Sparks) do f.Visible = false end
		for _, f in ipairs(Hit.Branches) do f.Visible = false end
	end

	function FxFn.HitLine(line, angle, length, thickness, color, duration, startRadius)
		line.Visible = true
		line.BackgroundColor3 = color
		line.BackgroundTransparency = 0
		line.Rotation = angle
		line.Size = UDim2.fromOffset(length, thickness)
		local rad = math.rad(angle)
		line.Position = UDim2.fromOffset(math.cos(rad) * startRadius, math.sin(rad) * startRadius)
		Tween(line, {Position = UDim2.fromOffset(math.cos(rad) * (startRadius + length * 0.55), math.sin(rad) * (startRadius + length * 0.55)), BackgroundTransparency = 1}, duration, Enum.EasingStyle.Quad)
	end

	function FxFn.ShowHitStyle(style, color, size, duration)
		local len = 10 * size
		local th = math.max(2, math.floor(2 * size + 0.5))
		if style == "Cross" then
			for i, a in ipairs({45,135,225,315}) do FxFn.HitLine(Hit.Lines[i], a, len, th, color, duration, 8 * size) end
		elseif style == "X" then
			for i, a in ipairs({45,135}) do FxFn.HitLine(Hit.Lines[i], a, len * 1.15, th, color, duration, 8 * size) end
		elseif style == "Plus" then
			for i, a in ipairs({0,90,180,270}) do FxFn.HitLine(Hit.Lines[i], a, len, th, color, duration, 8 * size) end
		elseif style == "Circle" then
			Hit.Ring.Visible = true; Hit.Ring.Size = UDim2.fromOffset(14 * size,14 * size); Hit.RingStroke.Color = color; Hit.RingStroke.Transparency = 0
			Tween(Hit.RingStroke, {Transparency = 1}, duration, Enum.EasingStyle.Quad)
			Tween(Hit.Ring, {Size = UDim2.fromOffset(42 * size,42 * size)}, duration, Enum.EasingStyle.Quad)
		elseif style == "Diamond" then
			for i, a in ipairs({45,135,225,315}) do FxFn.HitLine(Hit.Lines[i], a, len * 0.75, th, color, duration, 0) end
		elseif style == "Star" then
			for i, a in ipairs({0,45,90,135,180,225,270,315}) do FxFn.HitLine(Hit.Lines[i], a, len * 0.85, math.max(1, th - 1), color, duration, 5 * size) end
		elseif style == "Brackets" then
			local data = {{-1,-1,0},{-1,-1,90},{1,-1,180},{1,-1,90},{-1,1,270},{-1,1,0},{1,1,90},{1,1,180}}
			for i, d in ipairs(data) do FxFn.HitLine(Hit.Lines[i], d[3], len * 0.75, th, color, duration, 10 * size) end
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
			for i, a in ipairs({-62,-31,0,31,62}) do FxFn.HitLine(Hit.Lines[i], a - 90, len * 0.9, math.max(1, th - 1), color, duration, 8 * size) end
		end
	end

	function FxFn.ShowExplosion(color, size, duration)
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

	function FxFn.ShowLightning(color, size, duration)
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
		FxFn.HitHideAll()
		local color = kill and Color3.fromRGB(255,70,80) or Color3.new(1,1,1)
		local style = S.HitMarkerStyle or "Cross"
		local size = math.clamp(tonumber(S.HitMarkerSize) or 1, 0.5, 2.5)
		local duration = math.clamp(tonumber(S.HitMarkerLifetime) or 0.45, 0.12, 1.2)
		Hit.Scale.Scale = 1.45 * size
		Tween(Hit.Scale, {Scale = size}, 0.18, Enum.EasingStyle.Back)
		FxFn.ShowHitStyle(style, color, size, duration)

		local effect = S.HitEffect or "Pulse"
		if effect == "Pulse" or effect == "Pulse+Explosion" or effect == "Pulse+Lightning" or effect == "All" then
			Hit.Ring.Visible = true; Hit.Ring.Size = UDim2.fromOffset(10 * size,10 * size); Hit.RingStroke.Color = color; Hit.RingStroke.Transparency = 0
			Tween(Hit.Ring, {Size = UDim2.fromOffset(52 * size,52 * size)}, duration, Enum.EasingStyle.Quint)
			Tween(Hit.RingStroke, {Transparency = 1}, duration, Enum.EasingStyle.Quad)
		end
		if effect == "Explosion" or effect == "Pulse+Explosion" or effect == "Explosion+Lightning" or effect == "All" or style == "Hit" and kill then
			FxFn.ShowExplosion(color, size, duration)
		end
		if effect == "Lightning" or effect == "Pulse+Lightning" or effect == "Explosion+Lightning" or effect == "All" or style == "Lightning" then
			FxFn.ShowLightning(color, size, duration)
		end

		if S.HitSoundEnabled then
			pcall(function() Hit.Sound.PlaybackSpeed = kill and 1.5 or 1.1; Hit.Sound:Play() end)
		end
		task.delay(duration + 0.05, function()
			if token == Hit.Token then FxFn.HitHideAll() end
		end)
	end

	function FxFn.TrackHits(entity, e, firing)
		if not AimFn.EntryIsTargetable(entity, e, true, false) then e.LastHealth = nil; return end
		local alive = e.Refresh()
		local hum = e.Humanoid
		if not hum then e.LastHealth = nil; return end
		local hp = hum.Health
		if e.LastHealth and hp < e.LastHealth - 0.01 and firing then
			if hp <= 0 then
				if S.KillMarkerEnabled or S.HitMarkerEnabled then Hit.Show(true) end
			elseif S.HitMarkerEnabled then
				Hit.Show(false)
			end
		end
		e.LastHealth = alive and hp or nil
	end
	function FxFn.UpdateOverlay(dt)
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
				Esp.DrawLine(TargetLine, Vector2.new(vp.X * 0.5, vp.Y * 0.5), Vector2.new(sc.X, sc.Y), Theme.Accent, 1.5)
			else
				TargetLine.Visible = false
			end
		else
			TargetLine.Visible = false
		end


		FxFn.UpdateCrosshair(dt)
	end


	function Cfg.ApplyPreset(name)
		if name == "None" then return end
		for _, k in ipairs(WorldKeys) do Core.SetValue(k, Defaults[k]) end
		local p = Presets[name]
		if p then for k, v in pairs(p) do Core.SetValue(k, v) end end
		Core.Notify(string.format(Locale.T("TOAST_PRESET"), name))
	end
	Hooks.WorldPreset = Cfg.ApplyPreset

	function Cfg.SerializeConfig()
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
	function Cfg.DeserializeConfig(text)
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
				if nv ~= nil then Core.SetValue(k, nv); applied += 1 end
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
	function Cfg.RefreshConfigList()
		table.clear(ConfigIndex)
		local names = ListConfigs()
		for _, n in ipairs(names) do
			local ok, content = pcall(readfile, CONFIG_FOLDER .. "/" .. n .. ".cfg")
			if ok then ConfigIndex[n] = content end
		end
		ConfigListText = #names == 0 and Locale.T("TOAST_NOFOLDER") or table.concat(names, ", ")
	end
	Cfg.RefreshConfigList()
	function Cfg.PreviewFor(name)
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
	function Cfg.RenderLog()
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

	function Bld.Sec(l) return {t = "section", l = l} end
	function Bld.Tog(l, k) return {t = "toggle", l = l, k = k} end
	function Bld.Sld(l, k, mn, mx, d) return {t = "slider", l = l, k = k, min = mn, max = mx, dec = d} end
	function Bld.Cho(l, k, opts) return {t = "choice", l = l, k = k, opts = opts} end
	function Bld.ChoX(l, opts, get, set) return {t = "choice", l = l, opts = opts, get = get, set = set} end
	function Bld.Bnd(l, k) return {t = "bind", l = l, k = k} end
	function Bld.Act(l, fn) return {t = "action", l = l, fn = fn} end
	function Bld.Inp(id, ph, h, multi) return {t = "input", id = id, ph = ph, h = h, multi = multi} end
	function Bld.Inf(l, fn) return {t = "info", l = l, fn = fn} end
	function Bld.Lab(l) return {t = "label", l = l} end
	function Bld.Log() return {t = "log"} end
	function Bld.Avt() return {t = "avatar"} end
	function Bld.ColorSld(key, ch)
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
	function Bld.OverSld(store, key, ch)
		local idx = ({R = 1, G = 2, B = 3})[ch]
		local function cur() return store[key] or Theme[key] end
		return {t = "slider", raw = key .. " " .. ch, min = 0, max = 255, dec = 0,
			get = function()
				local c = cur()
				return math.floor(({c.R, c.G, c.B})[idx] * 255 + 0.5)
			end,
			set = function(v)
				local c = cur()
				local r, g, b = c.R * 255, c.G * 255, c.B * 255
				if idx == 1 then r = v elseif idx == 2 then g = v else b = v end
				store[key] = Color3.fromRGB(math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
				SaveTextColors()
				ApplyTheme()
			end}
	end
	function Bld.TextSld(key, ch) return Bld.OverSld(TextOverrides, key, ch) end
	function Core.Fmt2(sec)
		sec = math.floor(sec)
		return string.format("%02d:%02d:%02d", math.floor(sec / 3600), math.floor((sec % 3600) / 60), sec % 60)
	end

	local Spec = {}
	function Bld.Tab(key, loc, items) table.insert(Spec, {Key = key, Locale = loc, Items = items}) end

	Bld.Tab("AIMBOT", "TAB_AIMBOT", {
		Bld.Sec("SEC_AIMBOT"), Bld.Tog("OPT_AIMBOT","AimbotEnabled"), Bld.Tog("OPT_HOLD_RMB","AimHold"), Bld.Tog("OPT_TEAMCHECK","AimTeamCheck"), Bld.Tog("OPT_IGNOREBOT","AimIgnoreBots"), Bld.Tog("OPT_VISIBLECHECK","VisibleCheck"),
		Bld.Cho("OPT_AIMPART","AimPart",{"Head","Chest","Root"}), Bld.Sld("OPT_AIMSPEED","AimSpeed",1,60,0), Bld.Sld("OPT_FOVRADIUS","FOVRadius",20,500,0),
		Bld.Sld("OPT_MAXDIST","MaxAimDistance",100,5000,0), Bld.Tog("OPT_PREDICTION","PredictionEnabled"), Bld.Sld("OPT_PREDICTIONTIME","PredictionTime",0.02,0.4,2),
		Bld.Tog("OPT_SHOWFOV","ShowFOV"), Bld.Tog("OPT_TARGETLINE","ShowTargetLine"),
		Bld.Sec("SEC_TRIGGER"), Bld.Tog("OPT_TRIGGERBOT","TriggerEnabled"), Bld.Sld("OPT_TRIGGERFOV","TriggerFOV",1,100,0), Bld.Tog("OPT_SHOWTRIGGERFOV","ShowTriggerFOV"),
		Bld.Tog("OPT_HITBOX","TriggerHitbox"), Bld.Cho("OPT_TRIGGERPART","TriggerPart",{"Head","Body","Any"}), Bld.Tog("OPT_TEAMCHECK","TriggerTeamCheck"), Bld.Tog("OPT_IGNOREBOT","TriggerIgnoreBots"),
		Bld.Tog("OPT_WALLCHECK","TriggerWallCheck"), Bld.Tog("OPT_ONLYAIM","TriggerOnlyAim"), Bld.Sld("OPT_MAXDIST","TriggerMaxDistance",50,3000,0),
		Bld.Sld("OPT_REACTDELAY","TriggerDelay",0,0.5,2), Bld.Sld("OPT_FIREINTERVAL","TriggerInterval",0.02,0.6,2), Bld.Tog("OPT_HUMANIZE","TriggerHumanize"),
		Bld.Cho("OPT_CLICKMODE","TriggerClickMode",{"Auto","Tool"}),
	})
	Bld.Tab("VISUALS", "TAB_VISUALS", {
		Bld.Sec("SEC_ESP"), Bld.Tog("OPT_ESP","ESPEnabled"), Bld.Tog("OPT_HIDETEAM","ESPTeamCheck"), Bld.Tog("OPT_IGNOREBOT","ESPIgnoreBots"), Bld.Tog("OPT_BOXES","ShowBoxes"), Bld.Tog("OPT_CORNERBOXES","CornerBoxEnabled"),
		Bld.Tog("OPT_NAMES","ShowNames"), Bld.Tog("OPT_DISTANCE","ShowDistance"), Bld.Tog("OPT_HEALTHBAR","ShowHealth"), Bld.Tog("OPT_SKELETON","ShowSkeleton"),
		Bld.Tog("OPT_HEADDOT","ShowHeadDot"), Bld.Tog("OPT_WEAPON","ShowWeapon"), Bld.Tog("OPT_ITEMESP","ItemESPEnabled"), Bld.Tog("OPT_WORLDWEAPONESP","WeaponESPEnabled"), Bld.Tog("OPT_OFFSCREEN","ShowOffscreen"), Bld.Tog("OPT_CHAMS","ChamsEnabled"),
		Bld.Tog("OPT_TRACERS","ShowTracers"), Bld.Cho("OPT_TRACERORIGIN","TracerOrigin",TracerOriginNames), Bld.Cho("OPT_ESPCOLOR","ESPColor",ESPColorNames),
		Bld.Sld("OPT_ESPDIST","ESPMaxDistance",100,5000,0), Bld.Sld("OPT_WORLDESPDIST","WorldESPMaxDistance",100,3000,0),
	})
	Bld.Tab("MOVEMENT", "TAB_MOVEMENT", {
		Bld.Sec("SEC_MOVEMENT"), Bld.Tog("OPT_SPEED","SpeedEnabled"), Bld.Sld("OPT_WALKSPEED","SpeedValue",16,250,0), Bld.Tog("OPT_JUMPPOWER","JumpEnabled"),
		Bld.Sld("OPT_JUMPVALUE","JumpValue",50,300,0), Bld.Tog("OPT_FLY","FlyEnabled"), Bld.Sld("OPT_FLYSPEED","FlySpeed",20,300,0), Bld.Tog("OPT_NOCLIP","NoclipEnabled"),
		Bld.Tog("OPT_INFJUMP","InfJumpEnabled"),
	})
	Bld.Tab("PRESETS", "TAB_PRESETS", {
		Bld.Sec("SEC_PRESETS"), Bld.Cho("OPT_SCENEPRESET","WorldPreset",PresetNames),
	})
	Bld.Tab("RENDERING", "TAB_RENDERING", {
		Bld.Sec("SEC_RENDERING"), Bld.Tog("OPT_FULLBRIGHT","FullBrightEnabled"), Bld.Tog("OPT_NOSHADOWS","NoShadowsEnabled"), Bld.Tog("OPT_EXPOSURE","ExposureEnabled"),
		Bld.Sld("OPT_EXPOSUREVAL","Exposure",-3,3,1), Bld.Tog("OPT_HIDECLOUDS","HideCloudsEnabled"), Bld.Tog("OPT_GRAVITY","GravityEnabled"),
		Bld.Sld("OPT_GRAVITYVAL","GravityValue",10,400,0), 
		Bld.Sec("SEC_TIME"), Bld.Tog("OPT_FORCETIME","TimeOfDayEnabled"), Bld.Sld("OPT_TIMEOFDAY","TimeOfDay",0,24,1), Bld.Tog("OPT_TIMEFLOW","TimeFlowEnabled"),
		Bld.Sld("OPT_FLOWSPEED","TimeFlowSpeed",0.02,3,2),
		Bld.Sec("SEC_POSTFX"), Bld.Tog("OPT_GLOW","GlowEnabled"), Bld.Sld("OPT_GLOWINT","GlowIntensity",0,1,2), Bld.Sld("OPT_GLOWSIZE","GlowSize",1,56,0), Bld.Tog("OPT_COLORGRADE","ColorGradeEnabled"),
		Bld.Sld("OPT_SATURATION","ColorSaturation",-1,1,2), Bld.Sld("OPT_CONTRAST","ColorContrast",-1,1,2), Bld.Sld("OPT_BRIGHTNESS","ColorBrightness",-1,1,2),
		Bld.Cho("OPT_TINT","ColorTintName",WorldTintNames), Bld.Cho("OPT_VISIONMODE","VisionMode",VisionNames),
		Bld.Tog("OPT_DOF","DOFEnabled"), Bld.Sld("OPT_FOCUSDIST","DOFFocus",5,500,0), Bld.Sld("OPT_BLURAMOUNT","DOFFar",0,1,2), Bld.Sld("OPT_NEARBLUR","DOFNear",0,1,2), Bld.Sld("OPT_FOCUSRADIUS","DOFRadius",5,200,0),
		Bld.Tog("OPT_SCREENBLUR","BlurEnabled"), Bld.Sld("OPT_BLURSIZE","BlurSize",0,40,0), Bld.Tog("OPT_VIGNETTE","VignetteEnabled"), Bld.Sld("OPT_VIGNETTEINT","VignetteIntensity",0,1,2),
		Bld.Sec("SEC_AMBIENT"), Bld.Tog("OPT_AMBIENT","AmbientEnabled"), Bld.Cho("OPT_AMBIENTCOLOR","AmbientColorName",WorldTintNames), Bld.Sld("OPT_AMBIENTINT","AmbientIntensity",0,1,2),
		Bld.Sec("SEC_SKY"), Bld.Tog("OPT_STARS","StarsEnabled"), Bld.Sld("OPT_STARCOUNT","StarCount",500,10000,0),
	})
	Bld.Tab("CAMERA", "TAB_CAMERA", {
		Bld.Sec("SEC_CAMERA"), Bld.Tog("OPT_CUSTOMFOV","CustomFOVEnabled"), Bld.Sld("OPT_CAMERAFOV","CameraFOV",30,120,0), Bld.Tog("OPT_HOLDZOOM","ZoomEnabled"),
		Bld.Sld("OPT_ZOOMFOV","ZoomFOV",5,60,0), Bld.Tog("OPT_FREECAM","FreecamEnabled"), Bld.Sld("OPT_FREECAMSPEED","FreecamSpeed",10,300,0),
		Bld.Tog("OPT_ZOOMLIMIT","ZoomLimitEnabled"), Bld.Sld("OPT_MAXZOOM","ZoomLimit",10,500,0),
	})
	Bld.Tab("WEATHER", "TAB_WEATHER", {
		Bld.Sec("SEC_WEATHER"), Bld.Tog("OPT_SNOW","SnowEnabled"), Bld.Sld("OPT_SNOWDENSITY","SnowIntensity",5,150,0), Bld.Tog("OPT_RAIN","RainEnabled"),
		Bld.Sld("OPT_RAINDENSITY","RainIntensity",5,200,0), Bld.Sld("OPT_WIND","WindStrength",0,30,0), Bld.Tog("OPT_FOG","FogEnabled"), Bld.Sld("OPT_FOGDIST","FogDensity",30,800,0),
		Bld.Cho("OPT_FOGCOLOR","FogColorName",FogColorNames), Bld.Tog("OPT_LIGHTNING","LightningEnabled"), Bld.Sld("OPT_LIGHTNINGINT","LightningInterval",2,30,0),
		Bld.Sec("SEC_ATMOSPHERE"), Bld.Tog("OPT_ATMOSPHERE","AtmosphereEnabled"), Bld.Sld("OPT_ATMODENSITY","AtmoDensity",0,1,2), Bld.Sld("OPT_ATMOHAZE","AtmoHaze",0,10,1),
		Bld.Cho("OPT_ATMOCOLOR","AtmoColorName",FogColorNames), Bld.Tog("OPT_SUNRAYS","SunRaysEnabled"), Bld.Sld("OPT_RAYSINT","SunRaysIntensity",0,1,2),
		Bld.Sld("OPT_RAYSSPREAD","SunRaysSpread",0,1,2), Bld.Tog("OPT_RAINBOW","RainbowEnabled"), Bld.Sld("OPT_RAINBOWSPEED","RainbowSpeed",0.02,1,2),
		Bld.Sec("SEC_PARTICLES"), Bld.Tog("OPT_ASH","AshEnabled"), Bld.Sld("OPT_ASHINT","AshIntensity",5,150,0),
	})
	Bld.Tab("CROSSHAIR", "TAB_CROSSHAIR", {
		Bld.Sec("SEC_CROSSHAIR"), Bld.Tog("OPT_CUSTOMCROSS","CrosshairEnabled"),
		Bld.Sld("OPT_CROSSSIZE","CrosshairSize",2,30,0), Bld.Sld("OPT_CROSSGAP","CrosshairGap",0,20,0), Bld.Sld("OPT_CROSSTHICK","CrosshairThickness",1,6,0),
		Bld.Tog("OPT_CENTERDOT","CrosshairDot"), Bld.Tog("LBL_CROSS_OUTLINE","CrosshairOutline"), Bld.Cho("OPT_CROSSCOLOR","CrosshairColorName",CrosshairColorNames),
		Bld.Tog("OPT_SPIN","CrosshairSpin"), Bld.Tog("OPT_DYNAMICGAP","CrosshairDynamic"), Bld.Tog("OPT_REDONTARGET","CrosshairReactive"),
		Bld.Sec("SEC_HITFX"), Bld.Tog("OPT_HITMARKER","HitMarkerEnabled"), Bld.Tog("LBL_KILL_MARKER","KillMarkerEnabled"), Bld.Tog("OPT_HITSOUND","HitSoundEnabled"),
		Bld.Cho("OPT_HITSTYLE","HitMarkerStyle",HitMarkerStyles), Bld.Cho("OPT_HITEFFECT","HitEffect",HitEffects), Bld.Sld("OPT_HITSIZE","HitMarkerSize",0.5,2.5,1), Bld.Sld("OPT_HITTIME","HitMarkerLifetime",0.12,1.2,2),
	})
	Bld.Tab("PROFILE", "TAB_PROFILE", {
		Bld.Sec("SEC_ACCOUNT"), Bld.Avt(),
		Bld.Inf("LBL_USERNAME", function() return LocalPlayer.Name end), Bld.Inf("LBL_DISPLAYNAME", function() return LocalPlayer.DisplayName end),
		Bld.Inf("LBL_USERID", function() return tostring(LocalPlayer.UserId) end),
		Bld.Inf("LBL_ACCOUNTAGE", function() return LocalPlayer.AccountAge .. " " .. Locale.T("LBL_DAYS") end),
		Bld.Sec("SEC_SESSION"), Bld.Inf("LBL_SESSIONTIME", function() return Core.Fmt2(os.clock() - SessionStart) end),
		Bld.Inf("LBL_TEAM", function() local t = LocalPlayer.Team; return t and t.Name or Locale.T("LBL_NOTEAM") end),
		Bld.Inf("LBL_HEALTH", function() local h = Core.GetHumanoid(); return h and string.format("%d / %d", math.max(math.floor(h.Health), 0), math.floor(h.MaxHealth)) or "-" end),
		Bld.Inf("LBL_CHARSTATE", function() local h = Core.GetHumanoid(); if not h then return Locale.T("LBL_NOCHAR") end; return h.Health > 0 and Locale.T("LBL_ALIVE") or Locale.T("LBL_DEAD") end),
		Bld.Sec("SEC_SERVER"), Bld.Inf("LBL_PLACEID", function() return tostring(game.PlaceId) end),
		Bld.Inf("LBL_JOBID", function() return game.JobId ~= "" and game.JobId or "Studio" end),
		Bld.Inf("LBL_PLAYERCOUNT", function() return tostring(#Players:GetPlayers()) end), Bld.Inf("LBL_PING", function() return Core.GetPing() .. " ms" end),
	})
	Bld.Tab("DEBUG", "TAB_DEBUG", {
		Bld.Sec("SEC_LOG"),
		Bld.Act("BTN_REFRESHLOG", function() Cfg.RenderLog(); Core.Notify(Locale.T("TOAST_LOGREFRESH")) end),
		Bld.Act("BTN_CLEARLOG", function() DebugLog.Clear(); Cfg.RenderLog() end),
		Bld.Log(),
	})
	local bindItems = {Bld.Sec("SEC_SCRIPT"), Bld.Bnd("MENU_KEY", "Menu")}
	for _, k in ipairs(BindOrder) do table.insert(bindItems, Bld.Bnd(BindNameKeys[k], k)) end
	table.insert(bindItems, Bld.Bnd("BIND_ZOOM", "Zoom"))
	Bld.Tab("BINDS", "TAB_BINDS", bindItems)

	-- CoreGui is never disabled. The final VORTEX menu uses the resolved CoreGui/gethui host.
	local function SetCoreGuiBlocked(_state)
		pcall(function() StarterGui:SetCore("TopbarEnabled", true) end)
	end

	local Unload
	local SwitchSkin
	local function SetMenu(state)
		if MenuState.Open == state then return end
		MenuState.Open = state
		if Skin and type(Skin.Show) == "function" then
			local ok, err = pcall(Skin.Show, state)
			if not ok then DebugLog.Push("skin", tostring(err), true) end
		end
		CursorSys.Set(state)
		SetCoreGuiBlocked(state)
	end

	local st = {
		Bld.Sec("SEC_INTERFACE"), Bld.Sld("OPT_MENUTRANSP", "UIOpacity", 0, 0.5, 2),
		Bld.Sec("SEC_LANGUAGE"), Bld.ChoX("OPT_LANGUAGE", LanguageCodes, function() return Locale.Current end, function(v) Locale.SetLanguage(v, Core.Notify) end),
	}
	for _, it in ipairs({
		Bld.Sec("SEC_CONFIG"), Bld.Lab("LBL_CONFIGNAME"), Bld.Inp("cfgName", "PH_CONFIGNAME", 40, false), Bld.Lab("LBL_CONFIGSTRING"), Bld.Inp("cfgBox", "PH_CONFIGSTRING", 70, true),
		Bld.Act("BTN_EXPORT", function() Widgets.cfgBox.Text = Cfg.SerializeConfig(); Core.Notify(Locale.T("TOAST_EXPORTED")) end),
		Bld.Act("BTN_IMPORT", function()
			local ok, n = pcall(Cfg.DeserializeConfig, Widgets.cfgBox.Text)
			if not ok then DebugLog.Push("config", tostring(n), true) end
			if ok and n and n > 0 then Core.Notify(string.format(Locale.T("TOAST_IMPORTED"), n)) else Core.Notify(Locale.T("TOAST_IMPORTFAIL")) end
		end),
		Bld.Act("BTN_SAVE", function()
			local name = SanitizeFileName(Widgets.cfgName.Text)
			if not name or not EnsureFolder() then Core.Notify(Locale.T("TOAST_SAVEFAIL")); return end
			local ok = pcall(function() writefile(CONFIG_FOLDER .. "/" .. name .. ".cfg", Cfg.SerializeConfig()) end)
			Core.Notify(ok and string.format(Locale.T("TOAST_SAVED"), name) or Locale.T("TOAST_SAVEFAIL"))
			Cfg.RefreshConfigList()
		end),
		Bld.Act("BTN_LOAD", function()
			local name = SanitizeFileName(Widgets.cfgName.Text)
			if not name then Core.Notify(Locale.T("TOAST_LOADFAIL")); return end
			local content = ConfigIndex[name]
			if not content then
				local ok, c2 = pcall(function()
					local path = CONFIG_FOLDER .. "/" .. name .. ".cfg"
					if not isfile(path) then error("missing") end
					return readfile(path)
				end)
				if not ok then Core.Notify(Locale.T("TOAST_LOADFAIL")); return end
				content = c2
			end
			local ok2, n = pcall(Cfg.DeserializeConfig, content)
			if ok2 and n and n > 0 then Core.Notify(string.format(Locale.T("TOAST_LOADED_FILE"), name, n)) else Core.Notify(Locale.T("TOAST_IMPORTFAIL")) end
		end),
		Bld.Inf("LBL_SAVEDCONFIGS", function() return ConfigListText end),
		Bld.Inf("LBL_CONFIGPREVIEW", function() return Cfg.PreviewFor(Widgets.cfgName and Widgets.cfgName.Text) end),
		Bld.Act("BTN_REFRESH", function() Cfg.RefreshConfigList(); Core.Notify(Locale.T("TOAST_LOGREFRESH")) end),
		Bld.Act("BTN_RESET", function() for k, v in pairs(Defaults) do Core.SetValue(k, v) end; Core.Notify(Locale.T("TOAST_DEFAULTS")) end),
		Bld.Sec("SEC_QOL"),
		Bld.Tog("OPT_ANTIAFK", "AntiAFKEnabled"),
		Bld.Tog("OPT_CLICKTP", "ClickTPEnabled"),
		Bld.Tog("OPT_FPSCAP", "FPSCapEnabled"), Bld.Sld("OPT_FPSCAPVAL", "FPSCapValue", 30, 999, 0),
		Bld.Act("BTN_HOPSERVER", function()
			task.spawn(function()
				local ok, result = pcall(function()
					local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
					local res = HttpService:JSONDecode(game:HttpGet(url))
					local candidates = {}
					for _, srv in ipairs(res.data or {}) do
						if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then table.insert(candidates, srv.id) end
					end
					if #candidates == 0 then error("none") end
					return candidates[math.random(1, #candidates)]
				end)
				if ok then
					Core.Notify(Locale.T("TOAST_HOPQUEUED"))
					pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, result, LocalPlayer) end)
				else
					Core.Notify(Locale.T("TOAST_HOPFAIL"))
					DebugLog.Push("qol", "server hop failed: " .. tostring(result), true)
				end
			end)
		end),
	}) do table.insert(st, it) end
	Bld.Tab("SETTINGS", "TAB_SETTINGS", st)

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
		local get = it.get or function() return S[it.k] end
		local set = it.set or function(v) Core.SetValue(it.k, v) end
		Core.Connect(btn.MouseButton1Click, function() local v = not get(); set(v); paint(v) end)
		paint(get())
		if it.k and S[it.k] ~= nil then Core.Watch(it.k, function() paint(S[it.k]) end, true) end
	end
	local function ChoiceLogic(it, btn, paint)
		local get = it.get or function() return S[it.k] end
		local set = it.set or function(v) Core.SetValue(it.k, v) end
		local function show() paint(tostring(get())) end
		local function step(d)
			local i = table.find(it.opts, get()) or 1
			set(it.opts[(i - 1 + d) % #it.opts + 1])
			show()
		end
		Core.Connect(btn.MouseButton1Click, function() step(1) end)
		Core.Connect(btn.MouseButton2Click, function() step(-1) end)
		show()
		if it.k and S[it.k] ~= nil then Core.Watch(it.k, show, true) end
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
		Core.Watch(it.k, function()
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
			if it.set then it.set(v) else Core.SetValue(it.k, v) end
			show()
		end
		Core.Connect(hit.InputBegan, function(i) if Core.IsPointer(i) then Drag.Fn = fromX; fromX(i.Position.X) end end)
		show()
		if it.k and S[it.k] ~= nil then Core.Watch(it.k, show, true) end
	end
	local function BindLogic(it, btn, show)
		Core.Connect(btn.MouseButton1Click, function()
			if Listening then Listening.Show(Core.KeyName(K[Listening.Key])) end
			Listening = {Key = it.k, Show = show}
			show("...")
		end)
		show(Core.KeyName(K[it.k]))
	end
	local function Draggable(handle, target)
		Core.Connect(handle.InputBegan, function(i)
			if not Core.IsPointer(i) then return end
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
		for index, it in ipairs(tab.Items or {}) do
			local handler = C[it.t]
			if type(handler) ~= "function" then DebugLog.Push("ui", string.format("%s: unsupported control '%s' at %d", tostring(tab.Key), tostring(it.t), index), true)
			else local ok, err = pcall(handler, it, ctx); if not ok then DebugLog.Push("ui", string.format("%s: item %d failed: %s", tostring(tab.Key), index, tostring(err)), true) end end
		end
		if type(C.__finish) == "function" then local ok, err = pcall(C.__finish, ctx); if not ok then DebugLog.Push("ui", tostring(err), true) end end
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

	Skins.Sidebar = function()
		local Root = New("CanvasGroup", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(760,480),
			BackgroundColor3 = "@Secondary", Glass = 0, BorderSizePixel = 0, GroupTransparency = 1, Visible = false, ClipsDescendants = true})
		local Scale = New("UIScale", Root, {Scale = 0.9})
		local glow = GlowStroke(Root)
		local Top = New("Frame", Root, {Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3})
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
			Core.Connect(b.MouseEnter, function() Tween(b, {BackgroundColor3 = Theme.Border}, 0.12) end)
			Core.Connect(b.MouseLeave, function() Tween(b, {BackgroundColor3 = Theme.Row}, 0.12) end)
			Core.Connect(b.MouseButton1Click, cb)
		end
		TopBtn("X", Color3.fromRGB(255,90,100), -46, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		TopBtn("-", Theme.Text, -12, function() SetMenu(false) end)
		Draggable(Top, Root)

		local Side = New("Frame", Root, {Position = UDim2.fromOffset(0,48), Size = UDim2.fromOffset(160,432), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1})
		New("Frame", Side, {Size = UDim2.new(0,1,1,0), Position = UDim2.new(1,-1,0,0), BackgroundColor3 = "@Border", BorderSizePixel = 0, ZIndex = 1})
		local List = New("ScrollingFrame", Side, {Size = UDim2.new(1,0,1,-30), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y})
		New("UIListLayout", List, {Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", List, {PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,6)})
		local hint = New("TextLabel", Side, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,14,1,-10), Size = UDim2.new(1,-28,0,14), BackgroundTransparency = 1,
			TextColor3 = "@Muted", Font = GOTHM, TextSize = 9, TextXAlignment = LEFT, ZIndex = 4})
		local function PaintHint() hint.Text = Locale.T("MENU_KEY") .. "  " .. Core.KeyName(K.Menu) end
		PaintHint(); Locale.OnChange(PaintHint); table.insert(OnBind, PaintHint)
		local Content = New("Frame", Root, {Position = UDim2.fromOffset(160,48), Size = UDim2.new(1,-160,1,-48), BackgroundColor3 = "@Background", Glass = 0, BorderSizePixel = 0, ClipsDescendants = true})

		local Pages, Btns, Active = {}, {}, nil
		local function Select(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, b in pairs(Btns) do
				local active = n == name
				b.Bg.BackgroundTransparency = active and 0 or 1
				b.Bar.Visible = false
				b.Label.TextColor3 = active and Theme.TabTextActive or Theme.TabText
			end
		end
		table.insert(Refreshers, function() if Active then Select(Active) end end)

		local C = {}
		local function row(c, h, click)
			c.n += 1
			local parent = c.group or c.page
			local r = New(click and "TextButton" or "Frame", parent, {Size = UDim2.new(1,0,0,h), BackgroundColor3 = "@Row", Glass = 0, BorderSizePixel = 0, LayoutOrder = c.group and c.gn or c.n})
			if c.group then c.gn = (c.gn or 0) + 1 end
			if click then r.Text = ""; r.AutoButtonColor = false end
			Round(r, 8)
			local s = New("UIStroke", r, {Color = "@Border", Thickness = 1, Transparency = 0.3})
			Core.Connect(r.MouseEnter, function() Tween(s, {Color = Theme.Accent, Transparency = 0.5}, 0.15) end)
			Core.Connect(r.MouseLeave, function() Tween(s, {Color = Theme.Border, Transparency = 0.3}, 0.15) end)
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
			Core.CollapseOnScroll(h, group, chevron)
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
				Tween(track, {BackgroundColor3 = on and Theme.ToggleOn or Theme.Background}, 0.2)
				Tween(ts, {Color = on and Theme.Accent or Theme.Border}, 0.2)
				Tween(knob, {Position = on and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.ToggleKnobOn or Theme.ToggleKnobOff}, 0.2)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 54)
			Lbl(r, it, {Position = UDim2.fromOffset(14,8), Size = UDim2.new(1,-110,0,16), TextColor3 = "@Text", Font = GOTHM, TextSize = 12, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,8), Size = UDim2.fromOffset(90,16), BackgroundTransparency = 1,
				TextColor3 = "@SubText", Font = GOTHB, TextSize = 11, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(14,38), Size = UDim2.new(1,-28,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0}), 100)
			local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.fromOffset(12,12), BackgroundColor3 = "@SliderKnob", BorderSizePixel = 0, ZIndex = 3}), 100)
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
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-24,0,28), BackgroundColor3 = "@ButtonFill", TextColor3 = "@ButtonText",
				Font = GOTHB, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Core.Connect(b.MouseEnter, function() Tween(b, {BackgroundTransparency = 0.2}, 0.12) end)
			Core.Connect(b.MouseLeave, function() Tween(b, {BackgroundTransparency = 0}, 0.12) end)
			Core.Connect(b.MouseButton1Click, it.fn)
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

		local TabOrder = {}
		for _, tab in ipairs(Spec) do table.insert(TabOrder, tab) end

		local savedRootPos = LoadSetting("layout_root_pos", "")
		do
			local rx, ry = string.match(savedRootPos, "^(-?%d+),(-?%d+)$")
			if rx then Root.Position = UDim2.new(0.5, tonumber(rx), 0.5, tonumber(ry)) end
		end
		local function PersistRootPos()
			SaveSetting("layout_root_pos", math.floor(Root.Position.X.Offset) .. "," .. math.floor(Root.Position.Y.Offset))
		end
		local wasDraggingRoot = false
		Core.Connect(Top.InputBegan, function(i) if Core.IsPointer(i) then wasDraggingRoot = true end end)
		Core.Connect(UserInputService.InputEnded, function(input)
			if wasDraggingRoot and Core.IsPointer(input) then
				wasDraggingRoot = false
				task.defer(PersistRootPos)
			end
		end)

		-- The Sidebar skin historically rendered the shell but never populated its pages.
		-- Build the same full Spec through the native handler table so every standard menu is functional.
		for index, tab in ipairs(Spec) do
			local button = Round(New("TextButton", List, {Size = UDim2.new(1,0,0,34), BackgroundColor3 = "@Row", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = index}), 7)
			local bg = button
			local bar = New("Frame", button, {Size = UDim2.fromOffset(3,18), Position = UDim2.fromOffset(4,8), BackgroundColor3 = "@Accent", BorderSizePixel = 0, Visible = false})
			Round(bar, 2)
			local label = New("TextLabel", button, {Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,-20,1,0), BackgroundTransparency = 1, TextColor3 = "@TabText", Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
			Locale.Bind(label, tab.Locale)
			Btns[tab.Key] = {Bg = bg, Bar = bar, Label = label}
			local page = New("ScrollingFrame", Content, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = "@Accent", CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false})
			New("UIListLayout", page, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
			New("UIPadding", page, {PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,18), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
			Pages[tab.Key] = page
			BuildTab(tab, page, C)
			Core.Connect(button.MouseEnter, function() if Active ~= tab.Key then Tween(bg, {BackgroundTransparency = 0.35}, 0.12) end end)
			Core.Connect(button.MouseLeave, function() if Active ~= tab.Key then Tween(bg, {BackgroundTransparency = 1}, 0.12) end end)
			Core.Connect(button.MouseButton1Click, function() Select(tab.Key) end)
		end
		if Spec[1] then Select(Spec[1].Key) end

		return {
			Show = function(state) StandardShow(Root, Scale, state) end,
			Scale = function(v) if MenuState.Open then Tween(Scale, {Scale = v}, 0.1) end end,
			Opacity = function(v) if MenuState.Open then Tween(Root, {GroupTransparency = v}, 0.1) end end,
			Destroy = function() glow:Cancel() end,
		}
	end

	Skins.Floating = function()
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
			Core.CollapseOnScroll(h, group, chevron)
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
			local fill = New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0})
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
			Core.Connect(r.MouseButton1Click, it.fn)
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
				Core.Connect(x.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
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
			Core.Connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"), w.Fit)
			Core.Connect(arrow.MouseButton1Click, function() w.Open = not w.Open; w.Fit() end)
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

	Skins.Taskbar = function()
		local Root = New("Frame", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-14), Size = UDim2.fromOffset(660,490), BackgroundTransparency = 1, Visible = false})
		local Scale = New("UIScale", Root, {Scale = S.UIScale})
		local Panel = Round(New("CanvasGroup", Root, {Size = UDim2.fromOffset(660,428), BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1}), 16)
		local glow = GlowStroke(Panel)
		local head = New("Frame", Panel, {Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, BorderSizePixel = 0})
		New("Frame", head, {Position = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1), BackgroundColor3 = "@Border", BorderSizePixel = 0})
		local title = New("TextLabel", head, {Position = UDim2.fromOffset(16,0), Size = UDim2.new(1,-90,1,0), BackgroundTransparency = 1, TextColor3 = "@Text", Font = GOTHB, TextSize = 13, TextXAlignment = LEFT})
		local function HeadBtn(text, color, x, cb)
			local b = Round(New("TextButton", head, {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,x,0.5,0), Size = UDim2.fromOffset(26,26), BackgroundColor3 = "@Row",
				Text = text, TextColor3 = color, Font = GOTHB, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0}), 13)
			Core.Connect(b.MouseButton1Click, cb)
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
				local active = n == Active
				b.Btn.BackgroundTransparency = active and 0 or 1
				b.Label.TextColor3 = active and Theme.TabTextActive or Theme.TabText
			end
			if Active then
				for _, t in ipairs(Spec) do
					if t.Key == Active then
						local binding
						for _, entry in ipairs(Locale.Registry) do
							if entry.Instance == title and entry.Property == "Text" then binding = entry; break end
						end
						if binding then binding.Key = t.Locale; title.Text = Locale.T(t.Locale) else Locale.Bind(title, t.Locale) end
						break
					end
				end
			end
		end
		table.insert(Refreshers, function()
			for n, b in pairs(Btns) do b.Label.TextColor3 = n == Active and Theme.TabTextActive or Theme.TabText end
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
			Core.Connect(header.MouseEnter, function() hovering = true end)
			Core.Connect(header.MouseLeave, function() hovering = false end)
			Core.Connect(UserInputService.InputChanged, function(input)
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
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0}), 100)
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
			Core.Connect(r.MouseButton1Click, it.fn)
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
			Core.Connect(b.MouseButton1Click, function() Select(tab.Key) end)
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

	Skins.Console = function()
		local Root = New("CanvasGroup", MenuGui, {Name = "Main", AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,24), Size = UDim2.fromOffset(820,470),
			BackgroundColor3 = "@Background", BorderSizePixel = 0, GroupTransparency = 1, Visible = false})
		local Scale = New("UIScale", Root, {Scale = 0.94})
		New("UIStroke", Root, {Color = "@Accent", Thickness = 1})
		local Top = New("Frame", Root, {Size = UDim2.new(1,0,0,24), BackgroundColor3 = "@Secondary", BorderSizePixel = 0})
		local prompt = New("TextLabel", Top, {Position = UDim2.fromOffset(10,0), Size = UDim2.new(1,-90,1,0), BackgroundTransparency = 1, TextColor3 = "@Accent", Font = CODE, TextSize = 12, TextXAlignment = LEFT})
		local function TopBtn(text, color, x, cb)
			local b = New("TextButton", Top, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,x,0,0), Size = UDim2.fromOffset(34,24), BackgroundTransparency = 1, Text = text,
				TextColor3 = color, Font = CODE, TextSize = 12})
			Core.Connect(b.MouseButton1Click, cb)
		end
		TopBtn("[x]", Color3.fromRGB(255,90,100), 0, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
		TopBtn("[_]", Theme.Text, -34, function() SetMenu(false) end)
		Draggable(Top, Root)

		local Strip = New("Frame", Root, {Position = UDim2.fromOffset(0,24), Size = UDim2.new(1,0,0,26), BackgroundColor3 = "@Row", BorderSizePixel = 0})
		New("UIListLayout", Strip, {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder})
		local foot = New("TextLabel", Root, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,10,1,-4), Size = UDim2.new(1,-20,0,14), BackgroundTransparency = 1, TextColor3 = "@Muted",
			Font = CODE, TextSize = 10, TextXAlignment = LEFT})
		local function PaintFoot() foot.Text = Locale.T("MENU_KEY") .. ": " .. Core.KeyName(K.Menu) .. "   |   LMB click  RMB previous" end
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
			Core.Connect(r.MouseEnter, function() Tween(r, {BackgroundTransparency = 0.55}, 0.1) end)
			Core.Connect(r.MouseLeave, function() Tween(r, {BackgroundTransparency = 1}, 0.1) end)
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
			Core.CollapseOnScroll(h, group, chevron)
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
			local fill = New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0})
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
			Core.Connect(r.MouseButton1Click, it.fn)
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
			Core.Connect(b.MouseButton1Click, function() Select(tab.Key) end)
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

	Skins.Compact = function()
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
		Core.Connect(closeBtn.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
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
			for n, b in pairs(Btns) do b.Bg.BackgroundColor3 = n == name and Theme.Accent or Theme.Row end
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
			Core.CollapseOnScroll(h, group, chevron)
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
				Tween(track, {BackgroundColor3 = on and Theme.ToggleOn or Theme.Background}, 0.15)
				Tween(knob, {Position = on and UDim2.new(1,-14,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.ToggleKnobOn or Theme.ToggleKnobOff}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 46)
			Lbl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-90,0,14), TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.fromOffset(70,14), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 10, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0}), 100)
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
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,1,-8), BackgroundColor3 = "@ButtonFill", TextColor3 = "@ButtonText",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Core.Connect(b.MouseButton1Click, it.fn)
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
			Core.Connect(b.MouseButton1Click, function() Toggle(tab.Key) end)
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

	Skins.Overlay = function()
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
		Core.Connect(closeBtn.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)

		local hudAccum, hudFrames = 0, 0
		Core.Connect(RunService.RenderStepped, function(dt)
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
			for _, b in pairs(Segs) do b.BackgroundColor3 = Theme.Row end
		end
		local function OpenPanel(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, b in pairs(Segs) do b.BackgroundColor3 = n == name and Theme.Accent or Theme.Row end
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
			Core.CollapseOnScroll(h, group, chevron)
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
				Tween(track, {BackgroundColor3 = on and Theme.ToggleOn or Theme.Background}, 0.15)
				Tween(knob, {Position = on and UDim2.new(1,-14,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.ToggleKnobOn or Theme.ToggleKnobOff}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 46)
			Lbl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-90,0,14), TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.fromOffset(70,14), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 10, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0}), 100)
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
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,1,-8), BackgroundColor3 = "@ButtonFill", TextColor3 = "@ButtonText",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Core.Connect(b.MouseButton1Click, it.fn)
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
			Core.Connect(b.MouseButton1Click, function() Toggle(tab.Key) end)
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

	Skins.Wheel = function()
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
			for _, w in pairs(Wedges) do w.Icon.BackgroundColor3 = Theme.Row end
			closeBtn.Visible = false
		end
		local function OpenPanel(name)
			Active = name
			for n, p in pairs(Pages) do p.Visible = n == name end
			for n, w in pairs(Wedges) do w.Icon.BackgroundColor3 = n == name and Theme.Accent or Theme.Row end
			for _, t in ipairs(Spec) do if t.Key == name then panelTitle.Text = Locale.T(t.Locale) end end
			Panel.Visible = true; PanelOpen = true
			Tween(Panel, {Size = UDim2.fromOffset(360,380), GroupTransparency = 0}, 0.22, Enum.EasingStyle.Back)
			closeBtn.Visible = true
		end
		local function Toggle(name)
			if PanelOpen and Active == name then ClosePanel() else OpenPanel(name) end
		end
		Core.Connect(closeBtn.MouseButton1Click, function() DebugLog.Push("system", "close pressed, unloading"); Unload() end)
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
			Core.CollapseOnScroll(h, group, chevron)
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
				Tween(track, {BackgroundColor3 = on and Theme.ToggleOn or Theme.Background}, 0.15)
				Tween(knob, {Position = on and UDim2.new(1,-14,0.5,0) or UDim2.new(0,3,0.5,0), BackgroundColor3 = on and Theme.ToggleKnobOn or Theme.ToggleKnobOff}, 0.15)
			end)
		end
		function C.slider(it, c)
			local r = row(c, 46)
			Lbl(r, it, {Position = UDim2.fromOffset(12,6), Size = UDim2.new(1,-90,0,14), TextColor3 = "@Text", Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local val = New("TextLabel", r, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.fromOffset(70,14), BackgroundTransparency = 1, TextColor3 = "@SubText", Font = GOTHB, TextSize = 10, TextXAlignment = RIGHT})
			local track = Round(New("Frame", r, {Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = "@Background", BorderSizePixel = 0}), 100)
			local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = "@SliderFill", BorderSizePixel = 0}), 100)
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
			local b = Round(New("TextButton", r, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,1,-8), BackgroundColor3 = "@ButtonFill", TextColor3 = "@ButtonText",
				Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0}), 6)
			Locale.Bind(b, it.l)
			Core.Connect(b.MouseButton1Click, it.fn)
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
			Core.Connect(icon.MouseButton1Click, function() Toggle(tab.Key) end)
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

	-- Advanced Custom Menu runtime: declarative tabs, custom widgets, actions, cursor and interaction effects.
	local CustomState = {}
	local CustomTabApi = {Select = function() end}
	local function CustomColor(hex, fallback)
		if type(hex) ~= "string" then return fallback end
		local h = string.match(hex, "^#?(%x%x%x%x%x%x)$")
		if not h then return fallback end
		return Color3.fromRGB(tonumber(string.sub(h,1,2),16), tonumber(string.sub(h,3,4),16), tonumber(string.sub(h,5,6),16))
	end
	local function CustomAction(action, target, value)
		if action == "OpenTab" then
			CustomTabApi.Select(target)
		elseif action == "CloseMenu" then
			SetMenu(false)
		elseif action == "Unload" then
			Unload()
		elseif action == "Notify" then
			Core.Notify(tostring(value or target or "Custom action"))
		elseif action == "PlayEffect" then
			local fx = value or target
			if Skin and Skin.Root then CK.PlayEffects(Skin.Root, fx, {duration = CK.Custom.Effects.Duration, color = CK.Custom.Effects.Color, color2 = CK.Custom.Effects.Color2}) end
		elseif action == "ShakeMenu" then
			if Skin and Skin.Root then CK.PlayEffect(Skin.Root, tostring(value or target or "Shake"), {duration = 0.28, color = CK.Custom.Effects.Color}) end
		elseif action == "PlaySound" then
			local id = tostring(value or target or ""); if id ~= "" and Skin and Skin.Root then
				local s = Instance.new("Sound"); s.SoundId=id; s.Volume=CK.Custom.Effects.Volume or 0.55; s.Parent=Skin.Root; pcall(function() s:Play() end); task.delay(4,function() if s.Parent then s:Destroy() end end)
			end
		elseif action == "ToggleSetting" and target and S[target] ~= nil then
			Core.SetValue(target, not S[target])
		elseif action == "SetSetting" and target and S[target] ~= nil then
			Core.SetValue(target, value)
		elseif action == "Sequence" and type(value) == "table" then
			for _, step in ipairs(value) do
				if type(step) == "table" then
					local delayTime = tonumber(step.delay) or 0
					if delayTime > 0 then task.wait(delayTime) end
					CustomAction(step.action or "None", step.target, step.value or step.notify)
				end
			end
		end
	end
	local function CustomItemId(tabKey, item, index)
		return tostring(tabKey) .. ":" .. tostring(item.id or index)
	end
	local function BuildCustomItems(tab, page, C, x)
		local ctx = {page = page, n = 0}
		for i, raw in ipairs(tab.Items or {}) do
			local it = CloneTable(raw)
			it.t = it.t or it.type or "label"
			it.raw = it.text or it.raw or it.label or ""
			if it.t == "button" then it.t = "action" end
			it.events = type(it.events) == "table" and it.events or {}
			it.fx = it.fx or it.effects
			local stateKey = CustomItemId(tab.Key, it, i)
			if it.t == "toggle" then
				CustomState[stateKey] = CustomState[stateKey] == nil and (it.default == true) or CustomState[stateKey]
				if it.bind and S[it.bind] ~= nil then
					it.get = function() return S[it.bind] end
					it.set = function(v) Core.SetValue(it.bind, v) end
				else
					it.get = function() return CustomState[stateKey] == true end
					it.set = function(v) CustomState[stateKey] = v == true end
				end
			elseif it.t == "slider" then
				if CustomState[stateKey] == nil then CustomState[stateKey] = tonumber(it.default) or tonumber(it.min) or 0 end
				if it.bind and S[it.bind] ~= nil then
					it.get = function() return tonumber(S[it.bind]) or 0 end
					it.set = function(v) Core.SetValue(it.bind, v) end
				else
					it.get = function() return CustomState[stateKey] end
					it.set = function(v) CustomState[stateKey] = v end
				end
				it.min = tonumber(it.min) or 0; it.max = tonumber(it.max) or 100; it.dec = tonumber(it.dec) or 0
			elseif it.t == "choice" then
				it.opts = it.options or it.opts or {"One", "Two"}
				if #it.opts == 0 then it.opts = {"One"} end
				if CustomState[stateKey] == nil then CustomState[stateKey] = it.default or it.opts[1] end
				it.get = function() return CustomState[stateKey] end
				it.set = function(v) CustomState[stateKey] = v end
			elseif it.t == "input" then
				local parent = ctx.group or ctx.page
				ctx.n += 1
				local r = CK.Row(x, parent, tonumber(it.h) or 44, false, ctx.n)
				local box = New("TextBox", r, {Position = UDim2.fromOffset(12,7), Size = UDim2.new(1,-24,1,-14), BackgroundColor3 = "@Background", Text = CustomState[stateKey] or tostring(it.default or ""), PlaceholderText = tostring(it.placeholder or it.raw or ""), PlaceholderColor3 = "@Muted", TextColor3 = "@Text", Font = x.FM, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0, TextXAlignment = LEFT})
				Round(box, math.min(CK.Cfg.RowRadius or 8, 6)); New("UIPadding", box, {PaddingLeft = UDim.new(0,9), PaddingRight = UDim.new(0,9)})
				Core.Connect(box.FocusLost, function() CustomState[stateKey] = box.Text end)
				continue
			elseif it.t == "action" then
				local clickEv = it.events.click or {}
				local action = clickEv.action or it.action or "None"
				local target = clickEv.target or it.target
				local value = clickEv.value or clickEv.notify or it.value or it.notify or clickEv.actions
				it.fn = function() CustomAction(action, target, value) end
			elseif it.t == "section" then
				it.raw = it.raw ~= "" and it.raw or "CUSTOM"
			elseif it.t == "image" then
				it.image = tostring(it.image or "")
				it.h = tonumber(it.h) or 120
			end
			local fn = C[it.t]
			if fn then fn(it, ctx) end
		end
	end
	-- crez_custom v2: hub side of the "Custom" skin. All layout/looks come from CK.Build + CK.Cfg (written by the skin editor);
	-- this only plugs the real hub logic (settings, binds, locale, unload) into the engine.
	Skins.Custom = function()
		CK.NormalizeCustom()
		-- Layout presets are runtime overrides only. Never write them back into CK.Cfg.
		local c = {}
		for k, v in pairs(CK.Cfg) do c[k] = v end
		local lp = c.LayoutPreset
		if lp == "Sidebar" then c.Nav, c.NavStyle, c.Header = "Left", "Bar", "Full"
		elseif lp == "Floating" then c.Nav, c.NavStyle, c.Header, c.Radius = "Left", "Pill", "Slim", 18
		elseif lp == "Taskbar" then c.Nav, c.NavStyle, c.Header = "Bottom", "Pill", "Slim"
		elseif lp == "Console" then c.Nav, c.NavStyle, c.Header, c.Font = "Left", "Block", "Slim", "Code"
		elseif lp == "Compact" then c.Width, c.Height, c.RowH, c.TabH, c.Header = 640, 420, 32, 28, "Bare"
		elseif lp == "Overlay" then c.Backdrop, c.NavStyle, c.Radius = "Dark", "Pill", 14
		elseif lp == "Wheel" then c.Nav, c.NavStyle, c.TitleAlign = "Top", "Pill", "Center"
		end
		CK.EnsureCustomTabs((function() local keys = {}; for _, tab in ipairs(Spec) do table.insert(keys, tab.Key) end; return keys end)())
		if CK.Custom.Effects and type(CK.Custom.Effects.Open) == "string" then c.Open = CK.Custom.Effects.Open elseif CK.Custom.Effects and CK.Custom.Effects.MenuOpen then c.Open = CK.Custom.Effects.MenuOpen end
		local x = CK.Ctx(c, Core.Connect, Lbl, false)
		local bySpec = {}; for _, tab in ipairs(Spec) do bySpec[tab.Key] = tab end
		local tabs = {}
		for _, def in ipairs(CK.Custom.Tabs) do
			if def.Visible ~= false then
				local base = bySpec[def.Key]
				if base or def.Custom then
					local display = def.Title or ""
					local key = def.Key
					local titleObj = base and {Key = key, Locale = base.Locale} or {Key = key, Locale = nil}
					table.insert(tabs, {Key = key, base = base, def = def, label = function(parent, props)
						local t = New("TextLabel", parent, props)
						if display ~= "" then t.Text = display elseif titleObj.Locale then Locale.Bind(t, titleObj.Locale) else t.Text = key end
						return t
					end})
				end
			end
		end
		if #tabs == 0 then
			local first = Spec[1]
			table.insert(tabs, {Key = first.Key, base = first, def = {Key = first.Key, Visible = true, Custom = false, Items = {}}, label = function(parent, props) local t = New("TextLabel", parent, props); Locale.Bind(t, first.Locale); return t end})
		end
		local B
		local function BuildTabEntry(e, page, C)
			if e.def and e.def.Custom then
				BuildCustomItems(e.def, page, C, x)
			elseif e.base then
				BuildTab(e.base, page, C)
			end
		end
		B = CK.Build(x, MenuGui, {
			refreshers = Refreshers,
			title = {l = "APP_NAME"},
			tabs = tabs,
			buildTab = BuildTabEntry,
			logic = {toggle = ToggleLogic, slider = SliderLogic, choice = ChoiceLogic, bind = BindLogic, info = InfoReg, input = MakeInput, avatar = MakeAvatar},
			bindText = function(b, it) if it.l then Locale.Bind(b, it.l) else b.Text = it.raw or it.text or "" end end,
			collapse = Core.CollapseOnScroll,
			baseSub = function() return Locale.T("APP_SUB") .. "  |  " .. string.upper(LocalPlayer.Name) end,
			hintText = function() return Locale.T("MENU_KEY") .. "  " .. Core.KeyName(K.Menu) end,
			onLocale = function(fn) Locale.OnChange(fn) end,
			onBind = function(fn) table.insert(OnBind, fn) end,
			tick = function(fn) Core.Connect(RunService.Heartbeat, fn) end,
			onMin = function() SetMenu(false) end,
			onClose = function() DebugLog.Push("system", "close pressed, unloading"); Unload() end,
			draggable = Draggable,
			loadPos = function() return LoadSetting("custom_root_pos", "") end,
			savePos = function(v) SaveSetting("custom_root_pos", v) end,
			isPointer = Core.IsPointer,
			onLog = function(s) Widgets.log = s end,
			uiScale = S.UIScale,
			backdrop = true,
			userName = LocalPlayer.Name,
			displayName = LocalPlayer.DisplayName,
		})
		CustomTabApi.Select = B.Select
		return {
			Show = function(state) B.Show(state, S.UIScale, S.UIOpacity, function() return MenuState.Open end) end,
			Scale = function(v) if MenuState.Open then B.SetScale(v) end end,
			Opacity = function(v) if MenuState.Open then B.SetOpacity(v) end end,
			Destroy = function() CustomTabApi.Select = function() end; B.Destroy() end,
		}
	end

	-- ========================================================================
	-- VORTEX V5 TЗ EXTENSION LAYER
	-- Keeps the original V5 systems intact and layers advanced targeting,
	-- stability, rendering, HUD, binds, config tools and performance controls on top.
	-- ========================================================================
	local Adv = {
		LastTargetSwitch = 0,
		VisibilityClock = 0,
		BhopClock = 0,
		ShakeClock = 0,
		ShakeSeed = math.random() * 1000,
		CameraOriginalType = Camera.CameraType,
		CameraOriginalSubject = Camera.CameraSubject,
		BindHeld = {},
		BindModes = {},
		TriggerFireAfter = 0,
		TriggerBurstLeft = 0,
		TriggerBurstNext = 0,
		TargetEntity = nil,
		TargetPart = nil,
	}
	for _, k in ipairs(BindOrder) do
		Adv.BindModes[k] = S["Bind" .. k:gsub("Enabled", "") .. "Mode"] or "Toggle"
	end
	Adv.BindModes.Menu = S.BindMenuMode or "Toggle"
	Adv.BindModes.Zoom = S.BindZoomMode or "Hold"

	local function AdvKeyCode(raw, fallback)
		local ok, code = pcall(function() return Enum.KeyCode[tostring(raw)] end)
		return ok and code or fallback
	end
	local function AdvIsDown(raw, fallback)
		local code = AdvKeyCode(raw, fallback)
		return code and code ~= Enum.KeyCode.Unknown and UserInputService:IsKeyDown(code)
	end
	local function AdvSafeDestroy(x)
		if x then pcall(function() x:Destroy() end) end
	end
	local function AdvBindMatches(bind, input)
		if bind == nil or bind == Enum.KeyCode.Unknown then return false end
		if bind == input.KeyCode and input.UserInputType == Enum.UserInputType.Keyboard then return true end
		return bind == input.UserInputType
	end
	local function AdvBindName(bind)
		if bind == Enum.UserInputType.MouseButton1 then return "M1" end
		if bind == Enum.UserInputType.MouseButton2 then return "M2" end
		if bind == Enum.UserInputType.MouseButton3 then return "M3" end
		if bind == Enum.KeyCode.Unknown or bind == nil then return "NONE" end
		return bind.Name or tostring(bind)
	end
	local NativeKeyName = Core.KeyName
	function Core.KeyName(code)
		if code == Enum.UserInputType.MouseButton1 then return "M1" end
		if code == Enum.UserInputType.MouseButton2 then return "M2" end
		if code == Enum.UserInputType.MouseButton3 then return "M3" end
		return NativeKeyName(code)
	end

	local function AdvClassifyEntry(e)
		if not e or not e.IsBot then return "Player" end
		local now = os.clock()
		if e.KindCache and now - (e.KindCachedAt or 0) < 0.5 then return e.KindCache end
		local model = e.Entity
		local isBot = false
		pcall(function()
			isBot = model:GetAttribute("Bot") == true or model:GetAttribute("IsBot") == true or model:GetAttribute("NPCType") == "Bot"
			if not isBot then
				for _, tag in ipairs(game:GetService("CollectionService"):GetTags(model)) do
					local t = string.lower(tostring(tag))
					if t == "bot" or t == "ai" or t == "enemy" then isBot = true break end
				end
			end
		end)
		if not isBot then
			-- Match whole normalized name tokens, not arbitrary substrings like "GunfightMap" or "Botany".
			local normalized = tostring(model and model.Name or ""):gsub("([a-z])([A-Z])", "%1 %2"):lower():gsub("[^%w]+", " ")
			for token in normalized:gmatch("%w+") do
				if token == "bot" or token == "dummy" or token == "targetbot" then isBot = true; break end
			end
		end
		e.KindCache = isBot and "Bot" or "NPC"
		e.KindCachedAt = now
		return e.KindCache
	end

	-- Targetable classification: players, NPCs and bots are independent.
	function AimFn.EntryIsTargetable(entity, e, teamCheck, ignoreBots)
		if not e then return false end
		local kind = AdvClassifyEntry(e)
		e.Kind = kind
		if kind == "Bot" then
			if not S.AimAllowBots then return false end
			return not ignoreBots
		elseif kind == "NPC" then return S.AimAllowNPC == true
		end
		return entity ~= nil and AimFn.IsEnemy(entity, teamCheck)
	end

	-- Visual ESP uses an independent policy. Aimbot NPC/Bot permissions must never
	-- suppress their ESP; only the ESP-specific switches and team filter may do that.
	function Esp.EntryVisible(entity, e)
		if not e or S.ESPEnabled == false then return false end
		local kind = AdvClassifyEntry(e)
		e.Kind = kind
		if kind == "NPC" then return S.NPCESPEnabled ~= false end
		if kind == "Bot" then return S.BotESPEnabled ~= false and S.ESPIgnoreBots ~= true end
		if kind == "Player" then
			if S.PlayerESPEnabled == false or typeof(entity) ~= "Instance" or not entity:IsA("Player") or entity == LocalPlayer then return false end
			if S.ESPTeamCheck and entity.Team ~= nil and entity.Team == LocalPlayer.Team then return false end
			return true
		end
		return false
	end

	local function GetHealthRatio(e)
		if not e or not e.Humanoid or e.Humanoid.MaxHealth <= 0 then return 1 end
		return math.clamp(e.Humanoid.Health / e.Humanoid.MaxHealth, 0, 1)
	end
	local function GetAimPriorityScore(priority, screenD2, worldD2, health)
		if priority == "Closest Distance" then return worldD2
		elseif priority == "Lowest Health" then return health
		elseif priority == "Highest Health" then return 1 - health
		end
		return screenD2
	end
	local function DynamicAimFOV(distance)
		local base = math.max(1, tonumber(S.FOVRadius) or 150)
		if not S.DynamicFOVEnabled then return base end
		local maxD = math.max(1, tonumber(S.MaxAimDistance) or 1500)
		local closeness = 1 - math.clamp(distance / maxD, 0, 1)
		return base * (1 + math.clamp((tonumber(S.FOVDistanceScale) or 0.35) * closeness, 0, 1.5))
	end

	local function AimCandidateParts(e)
		local parts = {}
		local names = {"Head", "UpperTorso", "Torso", "HumanoidRootPart", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
		for _, name in ipairs(names) do
			local p = AimFn.PartOf(e, name)
			if p then table.insert(parts, p) end
		end
		return parts
	end
	function AimFn.GetAimPart(e)
		local mode = tostring(S.AimPart or "Head")
		if mode == "Head" then return AimFn.PartOf(e, "Head") or e.Root end
		if mode == "Chest" then return AimFn.PartOf(e, "UpperTorso") or AimFn.PartOf(e, "Torso") or AimFn.PartOf(e, "LowerTorso") or e.Root end
		if mode == "Root" then return e.Root end
		local candidates = AimCandidateParts(e)
		if #candidates == 0 then return e.Root end
		if mode == "Random" then return candidates[math.random(1, #candidates)] end
		if mode == "Nearest visible body part" then
			local best, bestD = nil, math.huge
			for _, p in ipairs(candidates) do
				local sc = Camera:WorldToViewportPoint(p.Position)
				if sc.Z > 0 and (not S.VisibleCheck or AimFn.IsVisible(p, e.Character, AimParams)) then
					local vp = Camera.ViewportSize
					local dx, dy = sc.X - vp.X * 0.5, sc.Y - vp.Y * 0.5
					local d2 = dx * dx + dy * dy
					if d2 < bestD then best, bestD = p, d2 end
				end
			end
			return best or e.Root
		end
		return e.Root
	end
	function AimFn.Predict(part)
		if not S.PredictionEnabled or not part then return part and part.Position or nil end
		local vel = part.AssemblyLinearVelocity or Vector3.zero
		local t = (tonumber(S.PredictionTime) or 0) * math.max(0, tonumber(S.AimPredictionMultiplier) or 1)
		local xz = S.PredictionHorizontal and Vector3.new(vel.X, 0, vel.Z) * t or Vector3.zero
		local y = S.PredictionVertical and Vector3.new(0, vel.Y * t, 0) or Vector3.zero
		return part.Position + xz + y
	end

	function AimFn.FindTarget()
		local entryCount = #EntryOrder
		if entryCount == 0 then return nil, nil, nil end
		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local camPos = Camera.CFrame.Position
		local maxDistSq = math.max(1, S.MaxAimDistance) ^ 2
		AimParams.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}
		local bestPart, bestPos, bestEntity, bestScore = nil, nil, nil, math.huge
		local lockedEntity = S.TargetLockEnabled and Aim.Player or nil
		local lockedFound = false
		for i = 1, entryCount do
			local entity = EntryOrder[i]
			local e = Entries[entity]
			if e and AimFn.EntryIsTargetable(entity, e, S.AimTeamCheck, S.AimIgnoreBots) and e.Refresh() then
				local part = AimFn.GetAimPart(e)
				local pos = part and AimFn.Predict(part)
				if part and pos then
					local delta = pos - camPos
					local worldD2 = delta:Dot(delta)
					if worldD2 <= maxDistSq then
						local sc = Camera:WorldToViewportPoint(pos)
						if sc.Z > 0 then
							local dx, dy = sc.X - center.X, sc.Y - center.Y
							local screenD2 = dx * dx + dy * dy
							local fov = DynamicAimFOV(math.sqrt(worldD2))
							if screenD2 <= fov * fov and (not S.VisibleCheck or AimFn.IsVisible(part, e.Character, AimParams)) then
								local score = GetAimPriorityScore(S.AimPriority, screenD2, worldD2, GetHealthRatio(e))
								if entity == lockedEntity then
									bestPart, bestPos, bestEntity, bestScore = part, pos, entity, score
									lockedFound = true
								elseif not lockedFound and score < bestScore then
									bestPart, bestPos, bestEntity, bestScore = part, pos, entity, score
								end
							end
						end
					end
				end
			end
		end
		if bestEntity and Aim.Player ~= bestEntity then
			local now = os.clock()
			if Aim.Player and (now - Adv.LastTargetSwitch) < math.max(0, tonumber(S.TargetSwitchDelay) or 0) then
				local old = Entries[Aim.Player]
				if old and old.Refresh() and AimFn.EntryIsTargetable(Aim.Player, old, S.AimTeamCheck, S.AimIgnoreBots) then
					local op = AimFn.GetAimPart(old)
					if op then
						local opos = AimFn.Predict(op)
						if opos and (not S.VisibleCheck or AimFn.IsVisible(op, old.Character, AimParams)) then
							bestPart, bestPos, bestEntity = op, opos, Aim.Player
						end
					end
				end
			end
			if bestEntity ~= Aim.Player then Adv.LastTargetSwitch = now end
		end
		return bestPart, bestPos, bestEntity
	end

	-- Smooth acceleration/deceleration for the aimbot; no hard camera snap.
	Aim.Update = function(dt)
		if not S.AimbotEnabled or Freecam.Active then
			Aim.CurrentResponse = 0
			Aim.Part, Aim.Position, Aim.Player = nil, nil, nil
			return
		end
		Aim.ScanAccum = (Aim.ScanAccum or 0) + dt
		local scan = S.PerformanceMode and 1/45 or (Aim.ScanInterval or 1/60)
		if Aim.Part == nil or Aim.ScanAccum >= scan then
			Aim.ScanAccum = 0
			Aim.Part, Aim.Position, Aim.Player = AimFn.FindTarget()
		end
		local hasTarget = Aim.Part and Aim.Position and Aim.Part.Parent and Aim.Player and Entries[Aim.Player]
		if not hasTarget then
			Aim.CurrentResponse = math.max(0, (Aim.CurrentResponse or 0) - math.max(0, tonumber(S.AimDeceleration) or 22) * dt)
			return
		end
		if S.AimHold and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
		local accel = math.max(0.01, tonumber(S.AimAcceleration) or 18)
		local decel = math.max(0.01, tonumber(S.AimDeceleration) or 22)
		Aim.CurrentResponse = math.min(1, (Aim.CurrentResponse or 0) + accel * dt)
		local smooth = math.clamp(tonumber(S.AimSmoothness) or 0.9, 0.05, 1)
		local rate = math.max(0.1, (tonumber(S.AimSpeed) or 14) * smooth)
		local response = 1 - math.exp(-rate * math.max(0.05, Aim.CurrentResponse) * dt)
		if response <= 0 then return end
		local cur = Camera.CFrame
		local pos = Aim.Position
		if (pos - cur.Position).Magnitude > 0.01 then
			Camera.CFrame = cur:Lerp(CFrame.lookAt(cur.Position, pos), math.clamp(response, 0, 1))
		end
		if Aim.CurrentResponse < 1 then Aim.CurrentResponse = math.min(1, Aim.CurrentResponse + accel * dt * 0.5) end
		if not hasTarget then Aim.CurrentResponse = math.max(0, Aim.CurrentResponse - decel * dt) end
	end

	-- NPC / Bot classification is applied lazily to legacy bot entries.
	for _, entity in ipairs(EntryOrder) do
		local e = Entries[entity]
		if e and e.IsBot then e.Kind = AdvClassifyEntry(e) end
	end
	Adv.OldNewBotEntry = Esp.NewBotEntry
	Esp.NewBotEntry = function(model)
		local e = Adv.OldNewBotEntry(model)
		if e then e.Kind = AdvClassifyEntry(e) end
		if model then
			Core.Connect(model.AncestryChanged, function(_, parent)
				if Unloaded then return end
				if parent == nil and Entries[model] then Esp.RemoveEntry(model) end
			end)
		end
		return e
	end

	Adv.NativeUpdateEntry = Esp.UpdateEntry
	Esp.UpdateEntry = function(entity, e, heavy)
		if not e or not e.Folder or not e.Folder.Parent then return end

		-- Generic models still use the GetBoundingBox path, but NPCs and Bots must
		-- follow their own switches instead of treating every generic model as a Bot.
		if e.IsGeneric then
			local genericKind = AdvClassifyEntry(e)
			e.Kind = genericKind
			if S.ESPEnabled == false
				or (genericKind == "Bot" and (S.BotESPEnabled == false or S.ESPIgnoreBots == true))
				or (genericKind == "NPC" and S.NPCESPEnabled == false) then
				Esp.HideEntry(e); return
			end
			Esp.UpdateGenericEntry(entity, e, true)
			if e.NameLabel then
				if genericKind == "Bot" then e.NameLabel.Text = Locale.T("BOT_LABEL") else e.NameLabel.Text = e.Entity and e.Entity.Name or "NPC" end
				e.NameLabel.Visible = e.Shown and S.ShowNames == true
			end
			if not S.ShowBoxes and e.Box then e.Box.Visible = false end
			if not S.ShowBoxes or S.CornerBoxEnabled ~= true then
				if e.Corners then for _, f in ipairs(e.Corners) do f.Visible = false end end
			end
			return
		end

		-- Reclassify on every update because Bot attributes/tags can appear after registration.
		local kind = AdvClassifyEntry(e)
		e.Kind = kind

		if S.ESPEnabled == false then Esp.HideEntry(e); return end
		if kind == "Player" and S.PlayerESPEnabled == false then Esp.HideEntry(e); return end
		if kind == "NPC" and S.NPCESPEnabled == false then Esp.HideEntry(e); return end
		if kind == "Bot" and (S.BotESPEnabled == false or S.ESPIgnoreBots == true) then Esp.HideEntry(e); return end
		if kind == "Player" and typeof(entity) == "Instance" and entity:IsA("Player") then
			if entity == LocalPlayer or (S.ESPTeamCheck and entity.Team ~= nil and entity.Team == LocalPlayer.Team) then
				Esp.HideEntry(e); return
			end
		end

		if e.BrokenUntil and os.clock() < e.BrokenUntil then Esp.HideEntry(e); return end
		local now = os.clock()
		local heavyNow = heavy
		if heavyNow then e.HeavyAt = now end

		local ok, err = pcall(Adv.NativeUpdateEntry, entity, e, heavyNow)
		if not ok then
			-- back off this entity for a second; log at most once every 5s per entity
			local t = os.clock()
			e.BrokenUntil = t + 1
			if t - (e.ErrLoggedAt or 0) > 5 then e.ErrLoggedAt = t; DebugLog.Push("esp", tostring(err), true) end
			Esp.HideEntry(e)
			return
		end

		-- Apply name visibility after native updates for every entity class.
		if e.NameLabel then
			if kind == "Bot" then
				e.NameLabel.Text = Locale.T("BOT_LABEL")
			elseif kind == "NPC" then
				e.NameLabel.Text = e.Entity and e.Entity.Name or "NPC"
			else
				e.NameLabel.Text = typeof(entity) == "Instance" and entity.Name or ""
			end
			e.NameLabel.Visible = e.Shown and S.ShowNames == true
		end

		-- Ensure corner segments cannot remain visible after their option is disabled.
		if not S.ShowBoxes or S.CornerBoxEnabled ~= true then
			if e.Corners then for _, f in ipairs(e.Corners) do f.Visible = false end end
		end
		if not S.ShowBoxes and e.Box then e.Box.Visible = false end
		if not e.Shown then return end

		local color
		if S.ESPRainbow then
			color = Color3.fromHSV((os.clock() * math.max(0.01, S.ESPRainbowSpeed)) % 1, 0.85, 1)
		elseif S.ESPDynamicColor and e.Humanoid then
			color = Color3.fromHSV(math.clamp(GetHealthRatio(e) * 0.33, 0, 0.33), 0.85, 1)
		else
			color = ESPColors[S.ESPColor] or ESPColors.Red
		end
		if S.ESPTeamColors and kind == "Player" and typeof(entity) == "Instance" and entity:IsA("Player") and entity.Team then
			color = entity.Team.TeamColor.Color
		end
		if S.ESPTargetHighlight and Aim.Player == entity then color = Core.TintColor(S.ESPTargetColorName) end
		-- Preserve the existing visibility-color feature.
		if S.ESPVisibilityColor and e.Character and e.Root then
			if now - (e.VisibilityAt or 0) >= 0.12 then
				e.VisibilityAt = now
				AimParams.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}
				e.VisibilityVisible = AimFn.IsVisible(e.Root, e.Character, AimParams)
			end
			if not e.VisibilityVisible then color = ESPColors[S.ESPHiddenColor] or Color3.fromRGB(255,70,80)
			else color = ESPColors[S.ESPVisibleColor] or Color3.fromRGB(90,235,130) end
		end
		if e.BoxStroke then e.BoxStroke.Color = color end
		if e.Dot then e.Dot.BackgroundColor3 = color end
		if e.Tracer then e.Tracer.BackgroundColor3 = color end
		if e.Arrow then e.Arrow.BackgroundColor3 = color end
		if e.NameLabel then e.NameLabel.TextColor3 = color end
		if e.HealthFill and e.Humanoid then
			local ratio = GetHealthRatio(e)
			e.HealthFill.BackgroundColor3 = S.ESPHealthGradient and Color3.fromHSV(ratio * 0.33, 0.85, 1) or color
		end
	end

	-- World Item/Weapon ESP. Each marker is a BillboardGui/Highlight tied to the real world object.
	Esp.WorldEntries = Esp.WorldEntries or {}
	Esp.WorldOrder = Esp.WorldOrder or {}
	Esp.WorldByAdornee = Esp.WorldByAdornee or {}
	local WeaponHints = {"weapon","gun","rifle","pistol","smg","shotgun","sniper","bow","crossbow","blade","sword","knife","katana","revolver","launcher","blaster","laser","spear","staff","wand"}
	local ItemHints = {"item","pickup","collect","loot","drop","crate","chest","case","ammo","med","health","armor","armour","coin","cash","key","token","gem","orb","pack","box","battery"}
	local function NameHasHint(name, hints)
		local n = tostring(name or ""):gsub("([a-z])([A-Z])", "%1 %2"):lower():gsub("[^%w]+", " ")
		local wanted = {}
		for _, h in ipairs(hints) do wanted[string.lower(tostring(h))] = true end
		for token in n:gmatch("%w+") do if wanted[token] then return true end end
		return false
	end
	local function WorldRoot(inst)
		if not inst or not inst.Parent then return nil end
		if inst:IsA("BasePart") then return inst end
		if inst:IsA("Tool") then return inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart", true) end
		if inst:IsA("Model") then return inst.PrimaryPart or inst:FindFirstChild("Handle", true) or inst:FindFirstChildWhichIsA("BasePart", true) end
		return nil
	end
	local function ClassifyWorld(inst)
		if not inst or not inst:IsDescendantOf(Workspace) then return nil end
		if inst == LocalPlayer.Character or Esp.IsUnderPlayerCharacter(inst) then return nil end
		local item, weapon = false, false
		local explicit = false
		local attr = inst:GetAttribute("ESPType")
		if type(attr) == "string" then
			attr = string.lower(attr)
			if attr == "item" or attr == "pickup" or attr == "loot" then item, explicit = true, true end
			if attr == "weapon" or attr == "gun" then weapon, explicit = true, true end
		end
		for _, key in ipairs({"Weapon", "IsWeapon", "Item", "IsItem", "Pickup", "Loot"}) do
			local ok, value = pcall(function() return inst:GetAttribute(key) end)
			if ok and value == true then
				if string.find(string.lower(key), "weapon", 1, true) then weapon = true else item = true end
				explicit = true
			end
		end
		pcall(function()
			local cs = game:GetService("CollectionService")
			for _, tag in ipairs(cs:GetTags(inst)) do
				local t = string.lower(tostring(tag))
				if t == "weapon" or t == "gun" or t == "weaponesp" then weapon = true; explicit = true end
				if t == "item" or t == "pickup" or t == "loot" or t == "collectible" or t == "itemesp" then item = true; explicit = true end
			end
		end)
		local cur = inst
		for _ = 1, 4 do
			if not cur or cur == Workspace then break end
			if cur ~= inst then
				if cur:IsA("Tool") then weapon = true; explicit = true end
				if not explicit and NameHasHint(cur.Name, WeaponHints) then weapon = true end
				if not explicit and NameHasHint(cur.Name, ItemHints) then item = true end
			end
			cur = cur.Parent
		end
		if not explicit then
			if NameHasHint(inst.Name, WeaponHints) then weapon = true end
			if NameHasHint(inst.Name, ItemHints) then item = true end
		end
		if weapon then return "Weapon" end
		if item then return "Item" end
		return nil
	end
	local function WorldEnabled(kind) return S.ESPEnabled and (kind == "Weapon" and S.WeaponESPEnabled or kind == "Item" and S.ItemESPEnabled) end
	local function RemoveWorldESP(inst)
		local e = Esp.WorldEntries[inst]
		if not e then return end
		if e.Highlight then pcall(function() e.Highlight:Destroy() end) end
		if e.Gui then pcall(function() e.Gui:Destroy() end) end
		local idx = e.Index
		local last = Esp.WorldOrder[#Esp.WorldOrder]
		if idx and Esp.WorldOrder[idx] == inst then
			Esp.WorldOrder[idx] = last; Esp.WorldOrder[#Esp.WorldOrder] = nil
			if last and Esp.WorldEntries[last] then Esp.WorldEntries[last].Index = idx end
		end
		Esp.WorldEntries[inst] = nil
		if e.Adornee then Esp.WorldByAdornee[e.Adornee] = nil end
	end
	local function NewWorldESP(inst, kind)
		if Esp.WorldEntries[inst] then return Esp.WorldEntries[inst] end
		local root = WorldRoot(inst)
		if not root or Esp.WorldByAdornee[root] or #Esp.WorldOrder >= 180 then return nil end
		local gui = New("BillboardGui", PlayerGui, {Name = "VortexWorldESP", ResetOnSpawn = false, Size = UDim2.fromOffset(170,42), AlwaysOnTop = true, LightInfluence = 0, MaxDistance = 100000, Enabled = false, Adornee = root, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, StudsOffsetWorldSpace = Vector3.new(0,1.7,0)})
		local card = Round(New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.fromRGB(8,8,12), BackgroundTransparency = 0.32, BorderSizePixel = 0}), 6)
		local stroke = New("UIStroke", card, {Thickness = 1.2})
		local title = New("TextLabel", card, {Position = UDim2.fromOffset(8,4), Size = UDim2.new(1,-16,0,16), BackgroundTransparency = 1, Text = tostring(inst.Name), TextColor3 = Color3.new(1,1,1), Font = GOTHB, TextSize = 11, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
		local sub = New("TextLabel", card, {Position = UDim2.fromOffset(8,20), Size = UDim2.new(1,-16,0,14), BackgroundTransparency = 1, Text = kind, Font = GOTHM, TextSize = 10, TextXAlignment = LEFT})
		local hi = Instance.new("Highlight")
		hi.Name = "VortexWorldHighlight"; hi.Adornee = (inst:IsA("Model") or inst:IsA("BasePart")) and inst or root; hi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hi.FillTransparency = 0.78; hi.OutlineTransparency = 0.08; hi.Parent = Workspace
		local color = kind == "Weapon" and Color3.fromRGB(255,175,70) or Color3.fromRGB(85,220,255)
		stroke.Color, sub.TextColor3, hi.FillColor, hi.OutlineColor = color, color, color, color
		local e = {Instance = inst, Adornee = root, Kind = kind, Gui = gui, Stroke = stroke, Title = title, Sub = sub, Highlight = hi, Index = #Esp.WorldOrder + 1, LastRefresh = 0}
		Esp.WorldEntries[inst] = e; Esp.WorldOrder[#Esp.WorldOrder+1] = inst; Esp.WorldByAdornee[root] = inst
		return e
	end
	local function TryRegisterWorld(inst)
		if Unloaded or not inst or not inst:IsDescendantOf(Workspace) then return end
		if inst:IsA("BasePart") and inst.Parent and (inst.Parent:IsA("Model") or inst.Parent:IsA("Tool")) then return end
		local kind = ClassifyWorld(inst); if kind then NewWorldESP(inst, kind) end
	end
	local function UpdateWorldESP()
		for i = #Esp.WorldOrder, 1, -1 do
			local inst = Esp.WorldOrder[i]; local e = Esp.WorldEntries[inst]
			if not e or not inst or not inst.Parent or not inst:IsDescendantOf(Workspace) then RemoveWorldESP(inst) else
				local root = WorldRoot(inst)
				if root and root.Parent then
					local dist = (root.Position - Camera.CFrame.Position).Magnitude
					local show = WorldEnabled(e.Kind) and dist <= (tonumber(S.WorldESPMaxDistance) or 1800)
					e.Gui.Adornee = root; e.Gui.Enabled = show; e.Highlight.Enabled = show
					if show and os.clock() - e.LastRefresh >= 0.2 then e.LastRefresh = os.clock(); e.Title.Text = tostring(inst.Name); e.Sub.Text = string.format("%s  |  %dm", e.Kind, math.floor(dist+0.5)) end
				else e.Gui.Enabled, e.Highlight.Enabled = false, false end
			end
		end
	end
	Core.Connect(Workspace.DescendantAdded, function(inst)
		local cur = inst
		for _ = 1, 6 do
			if not cur or cur == Workspace then break end
			if cur:IsA("Tool") or cur:IsA("Model") or cur:IsA("BasePart") then TryRegisterWorld(cur) end
			cur = cur.Parent
		end
	end)
	Core.Connect(Workspace.DescendantRemoving, function(inst)
		if Esp.WorldEntries[inst] then RemoveWorldESP(inst) end
	end)
	task.spawn(function() local all=Workspace:GetDescendants(); for i,inst in ipairs(all) do if Unloaded then break end; if inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("BasePart") then TryRegisterWorld(inst) end; if i%300==0 then task.wait() end end end)

	-- ESP runs in its own update path. This keeps it independent from FOV/HUD/crosshair
	-- failures and removes the old double-dispatch through FxFn.UpdateOverlay.
	local UpdateESPFiring = false
	local function UpdateOneEntry(entity, e)
		Esp.UpdateEntry(entity, e, S.ShowSkeleton == true)
		if S.HitMarkerEnabled or S.KillMarkerEnabled then
			FxFn.TrackHits(entity, e, UpdateESPFiring)
		else
			e.LastHealth = nil
		end
		if S.ChamsEnabled or e.Cham then Esp.UpdateCham(entity, e) end
	end
	local function UpdateESP(dt)
		if Unloaded or not ESPOverlay or not ESPOverlay.Parent then return end
		ESPOverlay.Enabled = true
		local count = #EntryOrder
		if count == 0 then return end

		local now = os.clock()
		UpdateESPFiring = (now - Combat.LastFire < 0.35) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

		for i = 1, count do
			local entity = EntryOrder[i]
			local e = entity and Entries[entity]
			if e and e.Folder and e.Folder.Parent then
				local ok, err = pcall(UpdateOneEntry, entity, e)
				if not ok then
					DebugLog.Push("esp", tostring(err), true)
					Esp.HideEntry(e)
				end
			end
		end

	end

	local TriggerScanRuntime = {Cursor = 1}
	local TriggerCandidates = {}
	local TriggerCandidateCount = 0
	local TRIGGER_MAX_CANDIDATES = 12
	function Trig.TriggerAddCandidate(entity, e, part, screenDistSq, worldDistSq)
		if TriggerCandidateCount < TRIGGER_MAX_CANDIDATES then
			TriggerCandidateCount += 1
			local c = TriggerCandidates[TriggerCandidateCount]
			if not c then c = {}; TriggerCandidates[TriggerCandidateCount] = c end
			c.Entity, c.Entry, c.Part, c.Distance, c.WorldDistanceSq = entity, e, part, screenDistSq, worldDistSq
			return
		end
		local worst = 1
		for i = 2, TriggerCandidateCount do
			if TriggerCandidates[i].Distance > TriggerCandidates[worst].Distance then worst = i end
		end
		if screenDistSq < TriggerCandidates[worst].Distance then
			local c = TriggerCandidates[worst]
			c.Entity, c.Entry, c.Part, c.Distance, c.WorldDistanceSq = entity, e, part, screenDistSq, worldDistSq
		end
	end

	-- Triggerbot v3: single targetability predicate (no AimFn swap/restore — a thrown error used to
	-- leave AimFn.EntryIsTargetable patched for every other consumer, including ESP, for the rest of
	-- the frame). Trigger part lists are cached per-entry and invalidated by character identity, not
	-- rebuilt via FindFirstChild(name, true) every candidate every tick. Every exit path clears lock
	-- state so a removed/Destroyed target can never wedge Trigger.Update into firing on stale refs.
	local function TriggerTargetable(entity, e)
		if not e then return false end
		local kind = AdvClassifyEntry(e)
		e.Kind = kind
		if kind == "Bot" then return S.TriggerAllowBots == true and S.TriggerIgnoreBots ~= true end
		if kind == "NPC" then return S.TriggerAllowNPC == true end
		if kind ~= "Player" then return false end
		return entity ~= nil and typeof(entity) == "Instance" and entity:IsA("Player") and AimFn.IsEnemy(entity, S.TriggerTeamCheck)
	end

	local function TriggerPartList(e)
		if not e then return nil end
		local ch = e.Character
		if not ch then return nil end
		if e.TriggerPartsChar == ch and e.TriggerPartsMode == S.TriggerBodyMode and os.clock() - (e.TriggerPartsAt or 0) < 1 then
			return e.TriggerParts
		end
		table.clear(e.TriggerParts)
		local preferred
		if S.TriggerBodyMode == "Head" then preferred = {"Head"}
		elseif S.TriggerBodyMode == "Body" then preferred = {"UpperTorso","Torso","LowerTorso","HumanoidRootPart","RootPart","Root"}
		else preferred = {"Head","UpperTorso","Torso","HumanoidRootPart","RootPart","Root","PrimaryPart"} end
		for _, name in ipairs(preferred) do
			local p = (name == "PrimaryPart" and ch.PrimaryPart) or ch:FindFirstChild(name)
			if p and p:IsA("BasePart") then e.TriggerParts[#e.TriggerParts + 1] = p end
		end
		if #e.TriggerParts == 0 and e.Root then e.TriggerParts[1] = e.Root end
		e.TriggerPartsChar, e.TriggerPartsMode, e.TriggerPartsAt = ch, S.TriggerBodyMode, os.clock()
		return e.TriggerParts
	end

	function Trig.CenterRayTarget()
		if not Camera then return nil, nil, nil end
		local p = Camera.ViewportSize / 2
		local ray = Camera:ViewportPointToRay(p.X, p.Y)
		local maxDist = math.max(tonumber(S.TriggerMaxDistance) or 1000, 1)
		TriggerParams.FilterDescendantsInstances = (LocalPlayer.Character and {LocalPlayer.Character}) or {}
		local hit = Workspace:Raycast(ray.Origin, ray.Direction * maxDist, TriggerParams)
		if not hit then return nil, nil, nil end
		local entity, e, hitPart = Trig.ResolveEntityFromHit(hit.Instance)
		if not entity or not e or not e.Refresh() or not TriggerTargetable(entity, e) then return nil, nil, nil end
		if e.Humanoid and e.Humanoid.Health <= 0 then return nil, nil, nil end
		local part = (hitPart and hitPart:IsA("BasePart") and e.Character and hitPart:IsDescendantOf(e.Character)) and hitPart
			or AimFn.PartOf(e, "Head") or e.Root
		if not part then return nil, nil, nil end
		return entity, part, e
	end

	function Trig.TriggerCandidateSort(a, b)
		local p = S.TriggerPriority or "Closest to Crosshair"
		if p == "Closest Distance" then return a.WorldDistanceSq < b.WorldDistanceSq end
		if p == "Lowest Health" or p == "Highest Health" then
			local ah, bh = GetHealthRatio(a.Entry), GetHealthRatio(b.Entry)
			if ah == bh then return a.Distance < b.Distance end
			return p == "Lowest Health" and ah < bh or ah > bh
		end
		return a.Distance < b.Distance
	end

	function Trig.FindTriggerTarget()
		local entity, part, e = Trig.CenterRayTarget()
		if entity then return entity, part, e end

		local now = os.clock()
		if now - (Trigger.LastScan or 0) < (Trigger.ScanInterval or (1 / 45)) then return nil, nil, nil end
		Trigger.LastScan = now

		local vp = Camera.ViewportSize
		local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
		local tanHalf = math.tan(math.rad(Camera.FieldOfView) * 0.5)
		local ppS = tanHalf > 0.0001 and (vp.Y / (2 * tanHalf)) or 1
		local camPos = Camera.CFrame.Position
		local maxDist = math.max(tonumber(S.TriggerMaxDistance) or 1000, 1)
		local maxDistSq = maxDist * maxDist

		TriggerCandidateCount = 0
		local count = #EntryOrder
		if count > 0 then
			local work = math.min(count, count <= 128 and count or 96)
			for _ = 1, work do
				if TriggerScanRuntime.Cursor > count then TriggerScanRuntime.Cursor = 1 end
				local ent = EntryOrder[TriggerScanRuntime.Cursor]
				TriggerScanRuntime.Cursor += 1
				local ent_e = ent and Entries[ent]
				if ent_e and ent_e.Refresh() and TriggerTargetable(ent, ent_e) then
					local root = ent_e.Root
					if root and root.Parent then
						local rootDelta = root.Position - camPos
						if rootDelta:Dot(rootDelta) <= maxDistSq then
							local parts = TriggerPartList(ent_e)
							for i = 1, parts and #parts or 0 do
								local part2 = parts[i]
								if part2 and part2.Parent then
									local delta = part2.Position - camPos
									local distSq = delta:Dot(delta)
									if distSq <= maxDistSq then
										local sc = Camera:WorldToViewportPoint(part2.Position)
										if sc.Z > 0 then
											local reach = S.TriggerFOV
											if S.TriggerHitbox then
												reach += math.max(part2.Size.X, part2.Size.Y) * 0.5 * ppS / math.max(sc.Z, 1)
											end
											local dx, dy = sc.X - center.X, sc.Y - center.Y
											local screenDistSq = dx * dx + dy * dy
											if screenDistSq <= reach * reach then
												Trig.TriggerAddCandidate(ent, ent_e, part2, screenDistSq, distSq)
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

		for i = 2, TriggerCandidateCount do
			local key = TriggerCandidates[i]
			local j = i - 1
			while j >= 1 and Trig.TriggerCandidateSort(key, TriggerCandidates[j]) do
				TriggerCandidates[j + 1] = TriggerCandidates[j]
				j -= 1
			end
			TriggerCandidates[j + 1] = key
		end

		for i = 1, TriggerCandidateCount do
			local c = TriggerCandidates[i]
			local ce = c.Entry
			if ce and ce.Refresh() and c.Part and c.Part.Parent then
				if not S.TriggerWallCheck or AimFn.IsVisible(c.Part, ce.Character, TriggerParams) then
					return c.Entity, c.Part, ce
				end
			end
		end
		return nil, nil, nil
	end

	function Trig.TriggerTargetStillValid(entity, part, e)
		if not entity or not part or not e or Entries[entity] ~= e then return false end
		if not part.Parent or not e.Refresh() then return false end
		if not TriggerTargetable(entity, e) then return false end
		if e.Humanoid and e.Humanoid.Health <= 0 then return false end
		local maxDist = math.max(tonumber(S.TriggerMaxDistance) or 1000, 1)
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
			if not AimFn.IsVisible(part, e.Character, TriggerParams) then return false end
		end
		return true
	end

	function Trigger.Update()
		if Unloaded or not S.TriggerEnabled or Freecam.Active or MenuState.Open or UserInputService:GetFocusedTextBox() then
			Trig.ResetTriggerState(); Trigger.BurstLeft = 0
			return
		end
		if S.TriggerOnlyAim and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			Trig.ResetTriggerState(); Trigger.BurstLeft = 0
			return
		end

		local now = os.clock()
		local currentEntity, currentPart = Trigger.Player, Trigger.Part
		local currentEntry = Trigger.Target and Entries[Trigger.Target] or nil
		local lockedValid = currentEntity and currentPart and currentEntry
			and Trig.TriggerTargetStillValid(currentEntity, currentPart, currentEntry)

		if not lockedValid then
			currentEntity, currentPart, currentEntry = Trig.FindTriggerTarget()
		end

		if not currentEntity or not currentPart or not currentEntry then
			if Trigger.Target and not Trigger.LostAt then Trigger.LostAt = now end
			if not Trigger.LostAt or now - Trigger.LostAt > 0.12 then
				Trig.ResetTriggerState()
				Trigger.BurstLeft = 0
				Trigger.LostAt = nil
			else
				Trigger.Player, Trigger.Part = nil, nil
			end
			return
		end
		Trigger.LostAt = nil

		if Trigger.Target ~= currentEntity then
			Trigger.Target = currentEntity
			Trigger.EnterTime = now
			Trigger.FireAfter = now + math.max(0, tonumber(S.TriggerDelay) or 0)
				+ (S.TriggerRandomDelay and math.random() * math.max(0, tonumber(S.TriggerRandomDelay) or 0) or 0)
			Trigger.BurstLeft = S.TriggerBurstEnabled and math.clamp(math.floor(tonumber(S.TriggerBurstCount) or 3), 1, 12) or 0
		end
		Trigger.Player, Trigger.Part = currentEntity, currentPart

		if now < (Trigger.FireAfter or now) then return end
		if now < (Trigger.NextFire or 0) then return end
		if not Trig.TriggerTargetStillValid(currentEntity, currentPart, currentEntry) then
			Trig.ResetTriggerState(); Trigger.BurstLeft = 0
			return
		end

		local fired = Trig.FireTrigger()
		if not fired then return end
		Combat.LastFire = now
		Trigger.LastFire = now

		if Trigger.BurstLeft and Trigger.BurstLeft > 0 then
			Trigger.BurstLeft -= 1
			if Trigger.BurstLeft > 0 then
				Trigger.NextFire = now + math.max(0.02, tonumber(S.TriggerBurstDelay) or 0.045)
				return
			end
			Trigger.BurstLeft = S.TriggerBurstEnabled and math.clamp(math.floor(tonumber(S.TriggerBurstCount) or 3), 1, 12) or 0
		end
		local minI = math.max(0.02, tonumber(S.TriggerMinInterval) or tonumber(S.TriggerInterval) or 0.1)
		local maxI = math.max(minI, tonumber(S.TriggerMaxInterval) or (minI * 1.4))
		Trigger.NextFire = now + minI + math.random() * (maxI - minI)
		if S.TriggerHumanize then
			Trigger.NextFire += (math.random() - 0.5) * math.max(0, tonumber(S.TriggerJitter) or 0.03)
		end
		Trigger.FireAfter = Trigger.NextFire
	end

	-- Movement additions with safe state handling.
	Adv.NativeMovementUpdate = Esp.UpdateMovement
	Esp.UpdateMovement = function()
		Adv.NativeMovementUpdate()
		local hum = Core.GetHumanoid()
		local root = hum and hum.RootPart
		if not hum or not root or hum.Health <= 0 then return end
		if S.NoFallEnabled and hum:GetState() == Enum.HumanoidStateType.Freefall then
			local v = root.AssemblyLinearVelocity
			if v.Y < -5 then root.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z) end
		end
		if S.AirWalkEnabled then
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
				local v = root.AssemblyLinearVelocity
				root.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
			end
		end
		if S.BunnyHopEnabled and hum.FloorMaterial ~= Enum.Material.Air and hum.MoveDirection.Magnitude > 0.05 then
			local now = os.clock()
			if now - Adv.BhopClock >= math.max(0.05, tonumber(S.BunnyHopInterval) or 0.12) then
				Adv.BhopClock = now
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end

	-- Camera smoothing, camera change resilience and optional shake.
	Adv.NativeWorldUpdate = World.Update
	function Core.ZoomHeld()
		if not S.ZoomEnabled or UserInputService:GetFocusedTextBox() then return false end
		if K.Zoom == Enum.UserInputType.MouseButton1 or K.Zoom == Enum.UserInputType.MouseButton2 or K.Zoom == Enum.UserInputType.MouseButton3 then
			return UserInputService:IsMouseButtonPressed(K.Zoom)
		end
		return K.Zoom ~= Enum.KeyCode.Unknown and UserInputService:IsKeyDown(K.Zoom)
	end
	World.Update = function(dt)
		-- The native update already handles zoom/FOV using Core.ZoomHeld; do not apply a second smoothing step.
		Adv.NativeWorldUpdate(dt)
	end
	if Workspace.GetPropertyChangedSignal then
		Core.Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
			local nextCam = Workspace.CurrentCamera
			if nextCam and nextCam ~= Camera then
				if Freecam.Active then Freecam.Stop() end
				Camera = nextCam
				Freecam.Camera = nil
				DebugLog.Push("camera", "CurrentCamera changed; systems rebound")
			end
		end)
	end
	Core.Connect(LocalPlayer.CharacterRemoving, function(ch)
		if Freecam.Active then Freecam.Stop() end
		Aim.Part, Aim.Position, Aim.Player = nil, nil, nil
		Trigger.Player, Trigger.Part, Trigger.Target, Trigger.EnterTime = nil, nil, nil, nil
		if Noclip.Character == ch then
			for part in pairs(Noclip.Parts) do if part.Parent then part.CanCollide = true end end
			table.clear(Noclip.Parts); table.clear(Noclip.BaseParts); Noclip.Character = nil
		end
	end)
	Core.Connect(LocalPlayer.CharacterAdded, function(ch)
		AdvSafeDestroy(Fly.Attach); Fly.Attach = nil
		Fly.Stop()
		Aim.Part, Aim.Position, Aim.Player = nil, nil, nil
		Trigger.Player, Trigger.Part, Trigger.Target, Trigger.EnterTime = nil, nil, nil, nil
		task.defer(function()
			if not Unloaded then Camera = Workspace.CurrentCamera or Camera end
		end)
		DebugLog.Push("character", "character added; targeting/movement state reset")
	end)

	-- Advanced target marker and trigger cooldown indicator.
	local TargetIndicator = Round(New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.fromOffset(16,16), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 12}), 100)
	local TargetIndicatorStroke = New("UIStroke", TargetIndicator, {Color = "@Accent", Thickness = 1.5, Transparency = 0.12})
	local TriggerCooldown = Round(New("Frame", Overlay, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(76,3), BackgroundColor3 = "@Border", BorderSizePixel = 0, Visible = false, ZIndex = 12}), 100)
	local TriggerCooldownFill = Round(New("Frame", TriggerCooldown, {Position = UDim2.fromScale(0,0), Size = UDim2.fromScale(0,1), BackgroundColor3 = "@Accent", BorderSizePixel = 0, ZIndex = 13}), 100)
	pcall(function()
		RunService:BindToRenderStep("VortexCameraEffects", Enum.RenderPriority.Camera.Value + 2, function(dt)
			if Unloaded or Freecam.Active or not S.CameraShakeEnabled then return end
			local intensity = math.max(0, tonumber(S.CameraShakeIntensity) or 0.8)
			local speed = math.max(0.1, tonumber(S.CameraShakeSpeed) or 16)
			Adv.ShakeClock += dt * speed
			local t = Adv.ShakeClock + Adv.ShakeSeed
			local x = math.noise(t, 0, 0) * intensity * 0.012
			local y = math.noise(0, t, 0) * intensity * 0.012
			local r = math.noise(0, 0, t) * intensity * 0.004
			Camera.CFrame = Camera.CFrame * CFrame.Angles(y, x, r)
		end)
	end)

	-- Settings helpers used by the extra controls below.
	local function AddTabItems(key, items)
		for _, tab in ipairs(Spec) do
			if tab.Key == key then
				local seen = {}
				for _, old in ipairs(tab.Items) do
					if old.k then seen[tostring(old.t) .. "|" .. tostring(old.k)] = true end
				end
				for _, it in ipairs(items) do
					local signature = it.k and (tostring(it.t) .. "|" .. tostring(it.k)) or nil
					if not signature or not seen[signature] then table.insert(tab.Items, it); if signature then seen[signature] = true end end
				end
				return true
			end
		end
		return false
	end
	local function ChoiceLabelOpts(list) local out = {}; for _, v in ipairs(list) do out[#out+1] = v end; return out end

	AddTabItems("VISUALS", {
		Bld.Sec("SEC_ESP_ADV"), Bld.Tog("LBL_PLAYER_ESP", "PlayerESPEnabled"), Bld.Tog("LBL_NPC", "NPCESPEnabled"), Bld.Tog("LBL_BOT", "BotESPEnabled"), Bld.Tog("LBL_HEALTH_PERCENT", "ESPHealthPercent"), Bld.Tog("LBL_HEALTH_GRADIENT", "ESPHealthGradient"),
		Bld.Tog("LBL_VISIBILITY_COLOR", "ESPVisibilityColor"), Bld.Cho("LBL_ESP_VISIBLE_COLOR", "ESPVisibleColor", ESPColorNames), Bld.Cho("LBL_ESP_HIDDEN_COLOR", "ESPHiddenColor", ESPColorNames),
		Bld.Tog("LBL_DYNAMIC_COLOR", "ESPDynamicColor"), Bld.Tog("LBL_RAINBOW", "ESPRainbow"), Bld.Sld("LBL_RAINBOW_SPEED", "ESPRainbowSpeed", 0.02, 1, 2), Bld.Tog("LBL_TEAM_COLORS", "ESPTeamColors"), Bld.Tog("LBL_TARGET_HIGHLIGHT", "ESPTargetHighlight"), Bld.Tog("LBL_LIMB", "ShowLimb"),
	})
	AddTabItems("RENDERING", {
		Bld.Sec("SEC_RENDER_PRESETS"), Bld.Cho("OPT_SCENEPRESET", "WorldPreset", PresetNames), Bld.Cho("LBL_RENDER_PRESET", "RenderPreset", {"Clean","Competitive","Dark","Bright","Cinematic","Performance"}),
	})

	-- Full bind mode controls. Existing key assignment remains intact, with mouse support added below.
	AddTabItems("BINDS", {Bld.Sec("SEC_BIND_MODES")})
	for _, key in ipairs(BindOrder) do
		local sk = "Bind" .. key:gsub("Enabled", "") .. "Mode"
		AddTabItems("BINDS", {Bld.ChoX(BindNameKeys[key], {"Toggle","Hold"}, function() return Adv.BindModes[key] end, function(v) Adv.BindModes[key] = v; S[sk] = v end)})
	end

	-- Configuration/QOL tools.
	AddTabItems("SETTINGS", {
		Bld.Sec("SEC_CONFIG_TOOLS"), Bld.Act("BTN_COPY", function()
			local code = Cfg.SerializeConfig(); local ok = pcall(setclipboard, code); Core.Notify(ok and Locale.T("TOAST_CONFIGCOPY") or Locale.T("TOAST_CLIPBOARDFAIL"))
			if Widgets.cfgBox then Widgets.cfgBox.Text = code end
		end),
		Bld.Act("BTN_DELETE", function()
			local name = SanitizeFileName(Widgets.cfgName and Widgets.cfgName.Text or "")
			if not name or not EnsureFolder() then return end
			local ok = pcall(function() if isfile(CONFIG_FOLDER .. "/" .. name .. ".cfg") then delfile(CONFIG_FOLDER .. "/" .. name .. ".cfg") else error("missing") end end)
			Cfg.RefreshConfigList(); Core.Notify(ok and Locale.T("TOAST_CONFIGDELETE") or Locale.T("TOAST_LOADFAIL"))
		end),
		Bld.Lab("LBL_RENAME_TO"), Bld.Inp("cfgRename", "PH_RENAME", 40, false),
		Bld.Act("BTN_RENAME", function()
			local old = SanitizeFileName(Widgets.cfgName and Widgets.cfgName.Text or ""); local new = SanitizeFileName(Widgets.cfgRename and Widgets.cfgRename.Text or "")
			if not old or not new or old == new or not EnsureFolder() then return end
			local ok = pcall(function()
				local a = CONFIG_FOLDER .. "/" .. old .. ".cfg"; local b = CONFIG_FOLDER .. "/" .. new .. ".cfg"
				if not isfile(a) then error("missing") end
				if isfile(b) and delfile then delfile(b) end
				writefile(b, readfile(a)); delfile(a)
			end)
			Cfg.RefreshConfigList(); Core.Notify(ok and Locale.T("TOAST_CONFIGRENAME") or Locale.T("TOAST_LOADFAIL"))
		end),
		Bld.Act("BTN_JSON_EXPORT", function()
			local obj = {}
			for k, v in pairs(S) do obj[k] = v end
			obj.__theme = {}; for _, key in ipairs(ThemeKeys) do local c = Themes.Custom[key]; obj.__theme[key] = {math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5)} end
			local raw = HttpService:JSONEncode(obj); if Widgets.cfgBox then Widgets.cfgBox.Text = raw end; pcall(setclipboard, raw)
			Core.Notify(Locale.T("TOAST_EXPORTED"))
		end),
		Bld.Act("BTN_JSON_IMPORT", function()
			local raw = Widgets.cfgBox and Widgets.cfgBox.Text or ""; local ok, obj = pcall(HttpService.JSONDecode, HttpService, raw)
			if not ok or type(obj) ~= "table" then Core.Notify(Locale.T("TOAST_IMPORTFAIL")); return end
			local n = 0
			for k, v in pairs(obj) do if k ~= "__theme" and S[k] ~= nil then Core.SetValue(k, v); n += 1 end end
			if type(obj.__theme) == "table" then for key, rgb in pairs(obj.__theme) do if Themes.Custom[key] and type(rgb) == "table" then Themes.Custom[key]=Color3.fromRGB(tonumber(rgb[1]) or 0, tonumber(rgb[2]) or 0, tonumber(rgb[3]) or 0); n+=1 end end; ApplyTheme() end
			Core.Notify(string.format(Locale.T("TOAST_IMPORTED"), n))
		end),
		Bld.Sec("SEC_RENDER_PRESETS"), Bld.Act("BTN_REJOIN", function() pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end),
		Bld.Act("BTN_COPY_JOB", function() local ok=pcall(setclipboard, game.JobId); Core.Notify(ok and game.JobId or Locale.T("TOAST_CLIPBOARDFAIL")) end),
		Bld.Act("BTN_COPY_SERVER", function() local txt=string.format("PlaceId=%s | JobId=%s | Players=%d", tostring(game.PlaceId), tostring(game.JobId), #Players:GetPlayers()); local ok=pcall(setclipboard, txt); Core.Notify(ok and txt or Locale.T("TOAST_CLIPBOARDFAIL")) end),
	})

	-- JSON preset import stays backward compatible because normal key/value configs remain unchanged.
	Adv.NativeApplyPreset = Cfg.ApplyPreset
	Cfg.ApplyPreset = function(name)
		Adv.NativeApplyPreset(name)
		if Adv and (name == "Clean" or name == "Competitive" or name == "Dark" or name == "Bright" or name == "Cinematic" or name == "Performance") then
			S.RenderPreset = name
		end
	end
	Hooks.WorldPreset = Cfg.ApplyPreset

	-- Render preset application for the new RenderPreset choice.
	Core.Watch("RenderPreset", function()
		local p = S.RenderPreset
		if not p or p == "Clean" then
			for _, key in ipairs(WorldKeys) do if Defaults[key] ~= nil then Core.SetValue(key, Defaults[key]) end end
			return
		end
		if p == "Competitive" then
			for k,v in pairs(Presets.Competitive) do Core.SetValue(k,v) end
		elseif p == "Dark" then for k,v in pairs(Presets.Dark) do Core.SetValue(k,v) end
		elseif p == "Bright" then for k,v in pairs(Presets.Bright) do Core.SetValue(k,v) end
		elseif p == "Cinematic" then for k,v in pairs(Presets.Cinematic) do Core.SetValue(k,v) end
		elseif p == "Performance" then for k,v in pairs(Presets.Performance) do Core.SetValue(k,v) end
		end
	end)


	-- Conflict-safe bind assignment helper exposed through debug logs.
	local function BindConflictReport()
		local seen, out = {}, {}
		for key, bind in pairs(K) do
			if bind ~= Enum.KeyCode.Unknown then
				local name = AdvBindName(bind)
				if seen[name] then out[#out+1] = name .. " (" .. tostring(seen[name]) .. ", " .. tostring(key) .. ")" else seen[name] = key end
			end
		end
		return out
	end
	local conflicts = BindConflictReport()
	if #conflicts > 0 then DebugLog.Push("binds", "conflicts detected: " .. table.concat(conflicts, "; "), true) end

	-- Panic / unload hotkeys. Panic simply routes through the existing full cleanup path.
	K.Panic = K.Panic or Enum.KeyCode.Delete
	K.Unload = K.Unload or Enum.KeyCode.End

	-- Shared skin lifecycle. Standard skins and the Custom skin use the same safe build/swap/cleanup path.
	local SkinResources
	local CurrentSkinName = skinName
	local function SetOfList(list)
		local out = {}
		for _, item in ipairs(list or {}) do out[item] = true end
		return out
	end
	local function SetOfMap(map)
		local out = {}
		for key in pairs(map or {}) do out[key] = true end
		return out
	end
	local function CaptureSkinResources()
		local sync = {}
		for key, callbacks in pairs(Sync) do sync[key] = SetOfList(callbacks) end
		return {
			children = SetOfList(MenuGui:GetChildren()),
			conns = SetOfList(Conns),
			refreshers = SetOfList(Refreshers),
			sync = sync,
			bound = SetOfList(Bound),
			localeRegistry = SetOfList(Locale.Registry),
			localeListeners = SetOfList(Locale.Listeners),
			infos = SetOfList(Infos),
			onbind = SetOfList(OnBind),
			widgets = SetOfMap(Widgets),
		}
	end
	local function RestoreListToBaseline(list, baseline)
		for i = #list, 1, -1 do if not baseline[list[i]] then table.remove(list, i) end end
	end
	local function RestoreWidgetsToBaseline(baseline)
		for key in pairs(Widgets) do if not baseline[key] then Widgets[key] = nil end end
	end
	local function CleanupSkinResources(resources, skinObj)
		if skinObj and type(skinObj.Destroy) == "function" then pcall(skinObj.Destroy) end
		if resources then
			for i = #Conns, 1, -1 do
				local c = Conns[i]
				if not resources.conns[c] then pcall(function() c:Disconnect() end); table.remove(Conns, i) end
			end
			RestoreListToBaseline(Refreshers, resources.refreshers)
			for key, callbacks in pairs(Sync) do
				local baseline = resources.sync[key]
				if baseline then RestoreListToBaseline(callbacks, baseline) else Sync[key] = nil end
			end
			RestoreListToBaseline(Bound, resources.bound)
			RestoreListToBaseline(Locale.Registry, resources.localeRegistry)
			RestoreListToBaseline(Locale.Listeners, resources.localeListeners)
			RestoreListToBaseline(Infos, resources.infos)
			RestoreListToBaseline(OnBind, resources.onbind)
			RestoreWidgetsToBaseline(resources.widgets)
			for _, child in ipairs(MenuGui:GetChildren()) do
				if not resources.children[child] then pcall(function() child:Destroy() end) end
			end
		end
	end
	local function BuildSkin(name, keepOpen)
		if Unloaded then return false end
		name = table.find(MenuSkinNames, name) and name or "Sidebar"
		local wasOpen = keepOpen == true and MenuState.Open == true
		local oldSkin, oldResources = Skin, SkinResources
		Skin, SkinResources = nil, nil
		CleanupSkinResources(oldResources, oldSkin)
		local resources = CaptureSkinResources()
		local builder = Skins[name] or Skins.Sidebar
		local ok, result = pcall(builder)
		if not ok or type(result) ~= "table" then
			DebugLog.Push("skin", name .. " build error: " .. tostring(result), true)
			CleanupSkinResources(resources, nil)
			if name ~= "Sidebar" then
				CurrentSkinName = "Sidebar"
				return BuildSkin("Sidebar", wasOpen)
			end
			return false
		end
		for _, method in ipairs({"Show", "Scale", "Opacity", "Destroy"}) do
			if type(result[method]) ~= "function" then
				DebugLog.Push("skin", name .. " missing " .. method .. " handler", true)
				result[method] = function() end
			end
		end
		Skin = result
		SkinResources = resources
		CurrentSkinName = name
		S.MenuStyle = name
		SaveSetting("menu_style", name)
		local shown, err = pcall(Skin.Show, wasOpen)
		if not shown then DebugLog.Push("skin", name .. " show error: " .. tostring(err), true) end
		CursorSys.Set(wasOpen)
		SetCoreGuiBlocked(wasOpen)
		DebugLog.Push("skin", "active menu style: " .. name)
		return true
	end
	SwitchSkin = function(name) return BuildSkin(name, MenuState.Open) end

	Hooks.MenuStyle = function(v)
		if not table.find(MenuSkinNames, v) then return end
		if CurrentSkinName ~= v then SwitchSkin(v) end
	end
	Hooks.UIScale = function(v) if Skin and type(Skin.Scale) == "function" then pcall(Skin.Scale, v) end end
	Hooks.UIOpacity = function(v) if Skin and type(Skin.Opacity) == "function" then pcall(Skin.Opacity, v) end end

	Unload = function()
		if Unloaded then return end
		Unloaded = true
		if Env.VortexUnload == Unload then Env.VortexUnload = nil end
		pcall(function() RunService:UnbindFromRenderStep("VortexAim") end)
		pcall(function() RunService:UnbindFromRenderStep("VortexCameraEffects") end)
		if Skin then pcall(Skin.Destroy) end
		Skin, SkinResources = nil, nil
		for _, c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
		table.clear(Conns)
		if Adv.BotAttributeConnections and Adv.UnwatchBotModel then
			local models = {}
			for model in pairs(Adv.BotAttributeConnections) do models[#models + 1] = model end
			for _, model in ipairs(models) do Adv.UnwatchBotModel(model) end
		end
		Freecam.Stop(); Fly.Stop()
		if CursorSys.ForcedOpen then CursorSys.ForcedOpen = false end
		CursorSys.DestroyVisual()
		UserInputService.MouseBehavior = InitialMouseBehavior
		UserInputService.MouseIconEnabled = InitialMouseIconEnabled
		SetCoreGuiBlocked(false)
		if QoL.FPSCapApplied ~= nil then pcall(function() setfpscap(0) end) end
		for part in pairs(Noclip.Parts) do if part.Parent then part.CanCollide = true end end
		table.clear(Noclip.Parts); table.clear(Noclip.BaseParts)
		local hum = Core.GetHumanoid()
		if hum then
			if Applied.Speed then hum.WalkSpeed = Applied.WalkSpeed end
			if Applied.Jump then hum.UseJumpPower = Applied.UseJumpPower; hum.JumpPower = Applied.JumpPower end
			pcall(function() hum.PlatformStand = false end)
		end
		World.Restore()
		for i = #EntryOrder, 1, -1 do
			local entity = EntryOrder[i]
			if Entries[entity] then Esp.RemoveEntry(entity) end
		end
		table.clear(EntryOrder); table.clear(EntryIndex)
		for _, e in pairs(Esp.WorldEntries or {}) do
			if e.Highlight then pcall(function() e.Highlight:Destroy() end) end
			if e.Gui then pcall(function() e.Gui:Destroy() end) end
		end
		table.clear(Esp.WorldEntries or {})
		table.clear(Esp.WorldOrder or {})
		table.clear(Esp.WorldByAdornee or {})
		table.clear(Refreshers); table.clear(Bound); table.clear(Locale.Registry); table.clear(Locale.Listeners)
		pcall(function() ESPOverlay:Destroy() end)
		Overlay:Destroy(); MenuGui:Destroy()
	end
	Env.VortexUnload = Unload

	BuildSkin(skinName, false)
	DebugLog.Push("ui", "final menu host: " .. tostring(VortexGuiHostKind))

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		local fab = Round(New("TextButton", MenuGui, {Name = "VortexTouchFab", Position = UDim2.fromOffset(12,120), Size = UDim2.fromOffset(42,42), BackgroundColor3 = "@Accent", Text = "V",
			TextColor3 = "@Background", Font = GOTHB, TextSize = 18, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 50}), 100)
		if SkinResources and SkinResources.children then SkinResources.children[fab] = true end
		Core.Connect(fab.MouseButton1Click, function() SetMenu(not MenuState.Open) end)
	end

	Core.Connect(UserInputService.InputChanged, function(input)
		local t = input.UserInputType
		if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end
		if Drag.Move then Drag.Move(input.Position) end
		if Drag.Fn then Drag.Fn(input.Position.X) end
	end)
	Core.Connect(UserInputService.InputEnded, function(input)
		if Core.IsPointer(input) then Drag.Move, Drag.Fn = nil, nil end
	end)
	Core.Connect(UserInputService.InputBegan, function(input, processed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not processed then Combat.LastFire = os.clock() end
		if Listening then
			local code = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
			if input.UserInputType == Enum.UserInputType.Keyboard and code == Enum.KeyCode.Escape then code = Enum.KeyCode.Unknown end
			if not (Listening.Key == "Menu" and code == Enum.KeyCode.Unknown) then K[Listening.Key] = code end
			Listening.Show(Core.KeyName(K[Listening.Key])); Listening = nil
			for _, fn in ipairs(OnBind) do pcall(fn) end
			return
		end
		if processed then return end
		if AdvBindMatches(K.Menu, input) then SetMenu(not MenuState.Open); return end
		if AdvBindMatches(K.Panic, input) or AdvBindMatches(K.Unload, input) then if Unload then Unload() end; return end
		for _, key in ipairs(BindOrder) do
			if AdvBindMatches(K[key], input) then
				if (Adv and Adv.BindModes and Adv.BindModes[key] or "Toggle") == "Hold" then Adv.BindHeld[key] = true; Core.SetValue(key, true)
				else Core.SetValue(key, not S[key]) end
				if (Adv and Adv.BindModes and Adv.BindModes[key] or "Toggle") ~= "Hold" then Core.Notify(Locale.T(BindNameKeys[key]) .. ": " .. Locale.T(S[key] and "LBL_ON" or "LBL_OFF")) end
			end
		end
	end)
	Core.Connect(UserInputService.InputEnded, function(input)
		for _, key in ipairs(BindOrder) do
			if Adv and Adv.BindModes and Adv.BindModes[key] == "Hold" and AdvBindMatches(K[key], input) then Adv.BindHeld[key] = false; Core.SetValue(key, false) end
		end
	end)
	Core.Connect(UserInputService.JumpRequest, function()
		if S.InfJumpEnabled then
			local hum = Core.GetHumanoid()
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end)

	Core.Connect(RunService.Stepped, function()
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

	function Esp.RegisterBotModel(model)
		if Unloaded or not model or not model:IsA("Model") or not model:IsDescendantOf(Workspace) then return nil end
		local canonical = Esp.CanonicalBotModel(model) or model
		local existing = Entries[canonical] or BotByModel[canonical]
		local hum = canonical:FindFirstChildOfClass("Humanoid")
		local root = hum and (hum.RootPart or canonical:FindFirstChild("HumanoidRootPart")) or nil
		if not existing and hum then existing = BotByHumanoid[hum] end
		if not existing and root then existing = BotByRoot[root] end
		if existing then
			if existing.Entity == canonical then
				if hum and root then existing.IsGeneric = false
				elseif not hum then existing.IsGeneric = true end
			end
			BotByModel[canonical] = existing
			if hum then BotByHumanoid[hum] = existing end
			if root then BotByRoot[root] = existing end
			return existing
		end
		local humanoidBot = Esp.IsBotModel(canonical)
		local generic = not humanoidBot and Esp.ShouldRegisterGenericModel(canonical)
		-- Never turn arbitrary models (map props, weapon models, pickups) into ESP entities.
		if not humanoidBot and not generic then return nil end
		if not root then root = Esp.FindModelRoot(canonical) end
		local entry = Esp.NewBotEntry(canonical)
		if entry then
			BotByModel[canonical] = entry
			if hum then BotByHumanoid[hum] = entry end
			if root then BotByRoot[root] = entry end
		end
		return entry
	end

	function Esp.TryRegisterBotFrom(inst)
		local cur = inst
		for _ = 1, 8 do
			if not cur or cur == Workspace then break end
			if cur:IsA("Model") then Esp.RegisterBotModel(cur) end
			cur = cur.Parent
		end
	end


	RegisterExistingPlayers(Esp, LocalPlayer)
	Core.Connect(Players.PlayerAdded, function(player) if player ~= LocalPlayer then Esp.NewPlayerEntry(player) end end)
	Core.Connect(Players.PlayerRemoving, function(player) Esp.RemoveEntry(player) end)
	Adv.BotAttributeConnections = setmetatable({}, {__mode = "k"})
	Adv.UnwatchBotModel = function(model)
		local list = Adv.BotAttributeConnections and Adv.BotAttributeConnections[model]
		if list then
			for _, conn in ipairs(list) do pcall(function() conn:Disconnect() end) end
			Adv.BotAttributeConnections[model] = nil
		end
	end
	Adv.PendingBotRegister = setmetatable({}, {__mode = "k"})
	function Adv.WatchBotModel(model)
		if not model or not model:IsA("Model") or Adv.BotAttributeConnections[model] then return end
		local list = {}
		Adv.BotAttributeConnections[model] = list
		for _, attr in ipairs({"Bot", "IsBot", "NPC", "NPCType", "ESP", "NoVortexESP"}) do
			local ok, signal = pcall(function() return model:GetAttributeChangedSignal(attr) end)
			if ok and signal then table.insert(list, signal:Connect(function()
				if not Unloaded and model:IsDescendantOf(Workspace) then task.defer(function() Esp.TryRegisterBotFrom(model) end) end
			end)) end
		end
		table.insert(list, model.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				Adv.UnwatchBotModel(model)
				local entry = Entries[model] or BotByModel[model]
				if entry and entry.Entity == model and entry.IsBot then Esp.RemoveEntry(entry.Entity) end
			end
		end))
	end
	function Adv.QueueBotRegistration(inst)
		local model = inst
		if not model or not model:IsA("Model") then
			model = inst and inst.Parent
			while model and model ~= Workspace and not model:IsA("Model") do model = model.Parent end
		end
		if not model or not model:IsA("Model") or model == Workspace or Adv.PendingBotRegister[model] then return end
		Adv.PendingBotRegister[model] = true
		task.defer(function()
			Adv.PendingBotRegister[model] = nil
			if not Unloaded and model:IsDescendantOf(Workspace) then Adv.WatchBotModel(model); Esp.TryRegisterBotFrom(model) end
		end)
	end
	Core.Connect(Workspace.DescendantAdded, function(inst)
		if inst:IsA("Model") then Adv.WatchBotModel(inst); Adv.QueueBotRegistration(inst)
		elseif inst:IsA("Humanoid") or inst:IsA("BasePart") then Adv.QueueBotRegistration(inst) end
	end)
	Core.Connect(Workspace.DescendantRemoving, function(inst)
		if inst:IsA("Model") then
			Adv.UnwatchBotModel(inst)
			local e = Entries[inst] or BotByModel[inst]
			if e and e.Entity == inst and e.IsBot then Esp.RemoveEntry(inst) end
		end
	end)
	for tagName in pairs({bot = true, npc = true, enemy = true, ai = true, esp = true}) do
		pcall(function()
			Core.Connect(game:GetService("CollectionService"):GetInstanceAddedSignal(tagName), function(inst)
				if inst and inst:IsA("Model") then Adv.WatchBotModel(inst); task.defer(function() Esp.TryRegisterBotFrom(inst) end) end
			end)
		end)
	end

	task.spawn(function()
		local descendants = Workspace:GetDescendants()
		for i, obj in ipairs(descendants) do
			if Unloaded then break end
			if obj:IsA("Model") and not Esp.IsUnderPlayerCharacter(obj) then
				Adv.WatchBotModel(obj)
				local hum = obj:FindFirstChildOfClass("Humanoid")
				local root = hum and (hum.RootPart or obj:FindFirstChild("HumanoidRootPart", true))
				if (hum and root) or Esp.ShouldRegisterGenericModel(obj) then Esp.RegisterBotModel(obj) end
			end
			if i % 250 == 0 then task.wait() end
		end
	end)

	Hud.InfoAccum = 0
	function Core.UpdateInfos(dt)
		Hud.InfoAccum += dt
		if Hud.InfoAccum < 0.5 then return end
		Hud.InfoAccum = 0
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
		-- The game camera (and other scripts) can re-lock the pointer after we set it once.
		-- While the menu is open it must stay free, so it is enforced every frame after the camera.
		if MenuState.Open then
			if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
			UserInputService.MouseIconEnabled = true
		end
	end)
	function Core.UpdateQoL(dt)
		CursorSys.Tick()
		if S.AntiAFKEnabled then
			local now = os.clock()
			if now - QoL.LastAFK >= 55 then
				QoL.LastAFK = now
				pcall(function()
					local vu = game:GetService("VirtualUser")
					vu:CaptureController()
					vu:ClickButton2(Vector2.new())
				end)
			end
		end
		if S.FPSCapEnabled then
			if QoL.FPSCapApplied ~= S.FPSCapValue then
				local ok = pcall(function() setfpscap(S.FPSCapValue) end)
				QoL.FPSCapApplied = ok and S.FPSCapValue or nil
				if not ok then Core.Notify(Locale.T("TOAST_FPSCAPFAIL")) end
			end
		elseif QoL.FPSCapApplied ~= nil then
			pcall(function() setfpscap(0) end) -- 0 = unlocked, executor-defined; FILL: adjust for your executor's uncap sentinel if different
			QoL.FPSCapApplied = nil
		end
	end
	Core.Connect(UserInputService.InputBegan, function(input, processed)
		if not S.ClickTPEnabled or processed then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then return end
		if S.NoclipEnabled then Core.Notify(Locale.T("TOAST_TPBLOCKED")); return end
		local hum = Core.GetHumanoid()
		local root = hum and hum.RootPart
		if not root then return end
		local p = CursorSys.AimPos
		local ray = Camera:ViewportPointToRay(p.X, p.Y)
		TPParams.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}
		local hit = Workspace:Raycast(ray.Origin, ray.Direction * 1000, TPParams)
		if hit then
			root.CFrame = CFrame.new(hit.Position + Vector3.new(0, root.Size.Y / 2 + 0.1, 0))
		end
	end)

	Core.Connect(RunService.RenderStepped, function(dt)
		if Unloaded then return end
		Camera = Workspace.CurrentCamera or Camera
		Safe("freecam", Freecam.Update, dt)
		Safe("world", World.Update, dt)
		Safe("fly", Fly.Update)
		Safe("movement", Esp.UpdateMovement)
		Safe("esp", UpdateESP, dt)
		Safe("worldesp", UpdateWorldESP)
		Safe("overlay", FxFn.UpdateOverlay, dt)
		Safe("profile", Core.UpdateInfos, dt)
		Safe("qol", Core.UpdateQoL, dt)
	end)

	SetMenu(true)
	Core.Notify(Locale.T("TOAST_LOADED"))
	DebugLog.Push("system", "hub loaded successfully")
	Cfg.RenderLog()
end

local function LoadCustomTheme()
	for _, k in ipairs(ThemeKeys) do
		local raw = LoadSetting("custom_theme_" .. k, "")
		local r, g, b = string.match(raw, "^(%d+),(%d+),(%d+)$")
		if r then Themes.Custom[k] = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
	end
	Prefs.GlassAlpha = tonumber(LoadSetting("custom_glass_alpha", "0")) or 0
	Prefs.AutoText = LoadSetting("custom_auto_text", "0") == "1"
	for _, k in ipairs(ElemKeys) do
		local r, g, b = string.match(LoadSetting("custom_elem_" .. k, ""), "^(%d+),(%d+),(%d+)$")
		if r then ElemOverrides[k] = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
	end
	for _, k in ipairs(TextKeys) do
		local r, g, b = string.match(LoadSetting("custom_text_" .. k, ""), "^(%d+),(%d+),(%d+)$")
		if r then TextOverrides[k] = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
	end
	ApplyTheme()
end
LoadCustomTheme()

SaveTextColors = function()
	SaveSetting("custom_auto_text", Prefs.AutoText and "1" or "0")
	for _, k in ipairs(ElemKeys) do
		local c = ElemOverrides[k]
		SaveSetting("custom_elem_" .. k, c and (math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5)) or "")
	end
	for _, k in ipairs(TextKeys) do
		local c = TextOverrides[k]
		SaveSetting("custom_text_" .. k, c and (math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5)) or "")
	end
end

local function SaveCustomTheme()
	for _, k in ipairs(ThemeKeys) do
		local c = Themes.Custom[k]
		SaveSetting("custom_theme_" .. k, math.floor(c.R*255+0.5) .. "," .. math.floor(c.G*255+0.5) .. "," .. math.floor(c.B*255+0.5))
	end
	SaveSetting("custom_glass_alpha", tostring(Prefs.GlassAlpha))
end

-- crez_custom v2: persistence + share codes for the brick config
function CK.Clip(v, max)
	v = string.gsub(tostring(v), "[;=|%c]", "")
	local n = utf8.len(v)
	if n and n > max then v = string.sub(v, 1, utf8.offset(v, max + 1) - 1) end
	return v
end
function CK.CfgString()
	local parts = {}
	for _, o in ipairs(CK.Schema) do
		local v = CK.Cfg[o.key]
		if o.kind == "text" then v = CK.Clip(v, o.max) end
		table.insert(parts, o.key .. "=" .. tostring(v))
	end
	return table.concat(parts, ";")
end
function CK.ParseCfg(raw)
	for k, v in string.gmatch(raw, "([%w_]+)=([^;|]*)") do
		local o = CK.ByKey[k]
		if o then
			if o.kind == "choice" then
				if table.find(o.opts, v) then CK.Cfg[k] = v end
			elseif o.kind == "text" then
				CK.Cfg[k] = CK.Clip(v, o.max)
			else
				local n = tonumber(v)
				if n then CK.Cfg[k] = math.clamp(n, o.min, o.max) end
			end
		end
	end
end
function CK.Save() SaveSetting("custom_cfg", CK.CfgString()) end
function CK.Load() CK.Reset(); CK.ParseCfg(LoadSetting("custom_cfg", "")) end
CK.Load()
CK.Custom = CK.Custom or {
	Version = 5,
	Effects = {
		Click = {"Ripple", "Pulse"}, Hover = {}, Press = {"Compress"}, Release = {"Bounce"}, RightClick = {"RippleSoft", "Echo"},
		Open = "Pop", OpenExtra = {"Pop", "Shine"}, Close = {"FadeOutIn"}, Tab = {"Slide", "Pop"}, TabHover = {},
		Duration = 0.18, Color = "FFFFFF", Color2 = "9F78FF",
		ClickSound = "", HoverSound = "", PressSound = "", ReleaseSound = "", TabSound = "", OpenSound = "", CloseSound = "",
		Volume = 0.55, Speed = 1, HoverScale = 1, PressScale = 0.95, HoverLift = 0, HoverRotation = 0,
		Stagger = 0.018, StaggerDirection = "Forward", ReduceMotion = false, SmoothTransitions = true,
	},
	Presets = {},
	Tabs = {},
}
local function CloneTable(v)
	local ok, out = pcall(function() return HttpService:JSONDecode(HttpService:JSONEncode(v)) end)
	return ok and out or {}
end
function CK.EnsureCustomTabs(keys)
	local previous = CK.Custom.Tabs or {}
	local existing = {}; local baseKeys = {}
	for _, t in ipairs(previous) do existing[t.Key] = t end
	local out = {}
	for _, key in ipairs(keys or {}) do
		baseKeys[key] = true
		local t = existing[key] or {Key = key, Title = "", Visible = true, Custom = false, Items = {}}
		t.Custom = false; t.Visible = t.Visible ~= false
		table.insert(out, t)
	end
	for _, t in ipairs(previous) do
		if t.Custom and not baseKeys[t.Key] then table.insert(out, t) end
	end
	CK.Custom.Tabs = out
	return out
end
function CK.NormalizeCustom()
	local c = CK.Custom
	if type(c) ~= "table" then c = {Version = 5}; CK.Custom = c end
	c.Version = 5
	c.Effects = type(c.Effects) == "table" and c.Effects or {}
	c.Tabs = type(c.Tabs) == "table" and c.Tabs or {}
	c.Presets = type(c.Presets) == "table" and c.Presets or {}
	local e = c.Effects
	local function list(v, fallback)
		if type(v) == "table" then return v end
		if type(v) == "string" and v ~= "" then return v end
		return fallback
	end
	e.Click = list(e.Click, {"Ripple", "Pulse"}); e.Hover = list(e.Hover, {}); e.Press = list(e.Press, {"Compress"}); e.Release = list(e.Release, {"Bounce"}); e.RightClick = list(e.RightClick, {"RippleSoft", "Echo"})
	e.Open = e.Open or "Pop"; e.OpenExtra = list(e.OpenExtra, {}); e.Close = list(e.Close, {"FadeOutIn"}); e.Tab = list(e.Tab, {"Slide", "Pop"}); e.TabHover = list(e.TabHover, {})
	e.Duration = math.clamp(tonumber(e.Duration) or 0.18, 0.04, 2); e.Color = e.Color or "FFFFFF"; e.Color2 = e.Color2 or "9F78FF"
	e.Volume = math.clamp(tonumber(e.Volume) or 0.55, 0, 1); e.Speed = math.clamp(tonumber(e.Speed) or 1, 0.2, 3)
	e.HoverScale = math.clamp(tonumber(e.HoverScale) or 1, 1, 1.12); e.PressScale = math.clamp(tonumber(e.PressScale) or 0.95, 0.82, 1)
	e.HoverLift = math.clamp(tonumber(e.HoverLift) or 0, 0, 14); e.HoverRotation = math.clamp(tonumber(e.HoverRotation) or 0, -12, 12)
	e.Stagger = math.clamp(tonumber(e.Stagger) or 0.018, 0, 0.25); e.StaggerDirection = tostring(e.StaggerDirection or "Forward")
	e.ReduceMotion = e.ReduceMotion == true; e.SmoothTransitions = e.SmoothTransitions ~= false
	e.ClickSound = tostring(e.ClickSound or ""); e.HoverSound = tostring(e.HoverSound or ""); e.PressSound = tostring(e.PressSound or ""); e.ReleaseSound = tostring(e.ReleaseSound or "")
	e.TabSound = tostring(e.TabSound or ""); e.OpenSound = tostring(e.OpenSound or ""); e.CloseSound = tostring(e.CloseSound or "")
	return c
end
function CK.SaveCustom()
	CK.NormalizeCustom()
	SaveSetting("custom_menu_def", HttpService:JSONEncode(CK.Custom))
end
function CK.LoadCustom()
	local raw = LoadSetting("custom_menu_def", "")
	if raw ~= "" then local ok, data = pcall(HttpService.JSONDecode, HttpService, raw); if ok and type(data) == "table" then CK.Custom = data end end
	CK.NormalizeCustom()
end
function CK.CustomCode()
	CK.NormalizeCustom(); return HttpService:JSONEncode(CK.Custom)
end
function CK.LoadAllCustom() CK.LoadCustom() end
CK.LoadCustom()
function CK.Export(cols, glass)
	local hex = {}
	for _, k in ipairs(ThemeKeys) do
		local c = cols[k]
		table.insert(hex, string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)))
	end
	local custom = HttpService:JSONEncode(CK.Custom):gsub("%%", "%%25"):gsub("|", "%%7C")
	return "VX3|" .. CK.CfgString() .. "|" .. table.concat(hex, ",") .. "|" .. string.format("%.3f", glass) .. "|" .. custom
end
function CK.Import(code)
	local version, cfg, hex, glass, custom = string.match(code, "^%s*(VX3)|([^|]*)|([^|]*)|([%d%.]+)|(.+)%s*$")
	if not version then version, cfg, hex, glass = string.match(code, "^%s*(VX2)|([^|]*)|([^|]*)|([%d%.]+)%s*$") end
	if version ~= "VX2" and version ~= "VX3" then return false end
	local cols, i = {}, 0
	for h in string.gmatch(hex, "(%x%x%x%x%x%x)") do
		i += 1
		local k = ThemeKeys[i]
		if k then cols[k] = Color3.fromRGB(tonumber(string.sub(h, 1, 2), 16), tonumber(string.sub(h, 3, 4), 16), tonumber(string.sub(h, 5, 6), 16)) end
	end
	if i < #ThemeKeys then return false end
	local customData = nil
	if version == "VX3" and custom and custom ~= "" then
		custom = custom:gsub("%%7C", "|"):gsub("%%25", "%%")
		local ok, data = pcall(HttpService.JSONDecode, HttpService, custom)
		if ok and type(data) == "table" then customData = data end
	end
	return true, cfg, cols, math.clamp(tonumber(glass) or 0, 0, 0.85), customData
end

local BuilderPresets = {
	{"Obsidian", {9,9,12},{14,14,18},{22,22,28},{42,42,52},{238,238,244},{150,150,164},{92,92,106},{150,110,255}},
	{"Blood", {13,6,7},{19,9,10},{28,14,16},{56,24,27},{244,236,237},{168,140,142},{108,86,88},{235,40,55}},
	{"Mint", {7,13,11},{10,19,16},{16,28,24},{32,56,48},{236,244,241},{150,172,164},{90,112,104},{60,220,160}},
	{"Royal", {8,8,16},{13,13,24},{20,20,36},{40,40,68},{238,238,248},{150,150,176},{92,92,120},{120,130,255}},
	{"Solar", {16,12,6},{24,18,10},{36,27,16},{66,50,30},{246,240,232},{176,158,140},{116,100,84},{255,170,40}},
	{"Paper", {236,236,240},{226,226,231},{214,214,220},{192,192,200},{20,20,24},{92,92,102},{140,140,150},{30,30,34}},
}

-- sample content for the preview: same tab names as the real hub, every component type
local PreviewTabKeys = {"AIMBOT", "VISUALS", "MOVEMENT", "PRESETS", "RENDERING", "CAMERA", "WEATHER", "CROSSHAIR", "PROFILE", "DEBUG", "BINDS", "SETTINGS"}
local function PreviewItems(key)
	local items = {}
	local function add(t) table.insert(items, t) end
	local function tog(name, def) add({t = "toggle", raw = name, k = key .. name, def = def}) end
	local function sld(name, mn, mx, def, dec) add({t = "slider", raw = name, k = key .. name, min = mn, max = mx, def = def, dec = dec or 0}) end
	local function cho(name, opts) add({t = "choice", raw = name, k = key .. name, opts = opts}) end
	if key == "AIMBOT" then
		add({t = "section", raw = "AIMBOT"}); tog("Enabled", true); tog("Hold to aim", true); tog("Team check", true); tog("Visible check", false)
		add({t = "section", raw = "TARGETING"}); cho("Aim part", {"Head", "Torso", "Nearest"}); sld("FOV radius", 20, 500, 0.3); sld("Smoothness", 1, 30, 0.45)
		add({t = "label", raw = "RMB while holding the aim key"})
		add({t = "action", raw = "RESET AIMBOT", fn = function() end})
	elseif key == "PROFILE" then
		add({t = "section", raw = "PLAYER"}); add({t = "avatar"})
		add({t = "info", raw = "Game", val = "Preview place"}); add({t = "info", raw = "Ping", val = "42 ms"})
	elseif key == "DEBUG" then
		add({t = "section", raw = "LOGS"}); add({t = "action", raw = "CLEAR LOG", fn = function() end}); add({t = "log"})
	elseif key == "BINDS" then
		add({t = "section", raw = "SCRIPT"}); add({t = "bind", raw = "Menu key", k = "bindMenu", key = "RightShift"}); add({t = "bind", raw = "Toggle aimbot", k = "bindAim", key = "E"})
		add({t = "bind", raw = "Fly", k = "bindFly", key = "F"})
	elseif key == "SETTINGS" then
		add({t = "section", raw = "INTERFACE"}); cho("Theme", {"Obsidian", "Crimson", "Ocean", "Custom"}); cho("Accent", {"Theme", "Violet", "Cyan"}); sld("Menu scale", 0.7, 1.3, 0.5, 2)
		add({t = "section", raw = "CONFIG"}); add({t = "input", id = "cfgName", raw = "Config name", h = 56}); add({t = "action", raw = "EXPORT CONFIG", fn = function() end})
	else
		add({t = "section", raw = key}); tog("Enabled", false); tog("Show names", true); sld("Distance", 100, 3000, 0.4); cho("Color", {"Red", "Green", "Blue"}); tog("Extra option", false)
	end
	return items
end

-- crez_custom v2: the skin editor. Workspace: brick box (left), the real menu running live (center), colors (right).
RunSkinBuilder = function(onDone, onCancel)
	local ACC = Color3.fromRGB(150,110,255)
	local K_BG, K_PANEL, K_ROW, K_LINE = Color3.fromRGB(11,11,15), Color3.fromRGB(17,17,22), Color3.fromRGB(27,27,34), Color3.fromRGB(48,48,58)
	local K_TEXT, K_SUB, K_MUTE = Color3.fromRGB(236,236,242), Color3.fromRGB(160,160,174), Color3.fromRGB(104,104,118)

	local function Capture()
		local st = {cfg = {}, cols = {}, glass = Prefs.GlassAlpha, custom = CloneTable(CK.Custom)}
		for k, v in pairs(CK.Cfg) do st.cfg[k] = v end
		for _, k in ipairs(ThemeKeys) do st.cols[k] = Themes.Custom[k] end
		return st
	end
	local snap = Capture()
	snap.theme, snap.accent = Prefs.Theme, Prefs.Accent
	Prefs.Theme, Prefs.Accent = "Custom", "Theme"
	CK.SyncTheme()

	local gui = New("ScreenGui", PlayerGui, {Name = "VortexSkinBuilder", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 1100})
	local dim = New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true})
	local card = Round(New("CanvasGroup", gui, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromScale(0.96,0.94),
		BackgroundColor3 = K_BG, BorderSizePixel = 0, GroupTransparency = 1}), 14)
	New("UISizeConstraint", card, {MinSize = Vector2.new(640,360), MaxSize = Vector2.new(1500,860)})
	local scale = New("UIScale", card, {Scale = 0.94})
	New("UIStroke", card, {Color = K_LINE, Thickness = 1.5})

	local conns = {}
	local function Keep(cn) table.insert(conns, cn); return cn end

	New("TextLabel", card, {Position = UDim2.fromOffset(24,12), Size = UDim2.new(1,-360,0,24), BackgroundTransparency = 1, Text = "BUILD YOUR MENU",
		TextColor3 = K_TEXT, Font = GOTHB, TextSize = 20, TextXAlignment = LEFT})
	New("TextLabel", card, {Position = UDim2.fromOffset(24,37), Size = UDim2.new(1,-48,0,16), BackgroundTransparency = 1,
		Text = "the middle is your real menu running live: click tabs, flip toggles, drag sliders. click any part of it to jump to its settings.",
		TextColor3 = K_SUB, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
	local statusLbl = New("TextLabel", card, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-24,0,16), Size = UDim2.fromOffset(320,16), BackgroundTransparency = 1, Text = "",
		TextColor3 = ACC, Font = GOTHB, TextSize = 11, TextXAlignment = RIGHT})
	local sayToken = 0
	local function Say(text)
		sayToken += 1
		local my = sayToken
		statusLbl.Text = text
		task.delay(2.5, function() if my == sayToken and statusLbl.Parent then statusLbl.Text = "" end end)
	end

	local body = New("Frame", card, {Position = UDim2.fromOffset(0,62), Size = UDim2.new(1,0,1,-118), BackgroundTransparency = 1})
	local function MakePanel()
		local p = Round(New("ScrollingFrame", body, {BackgroundColor3 = K_PANEL, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = ACC,
			CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}), 10)
		New("UIListLayout", p, {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", p, {PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,12)})
		return p
	end
	local colL, colR = MakePanel(), MakePanel()
	local colC = New("Frame", body, {BackgroundTransparency = 1})

	local drag = nil
	local PushUndo
	local function BeginDrag(input, fn, noHistory)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not noHistory then PushUndo() end
		drag = fn
		fn(input.Position)
	end
	Keep(UserInputService.InputChanged:Connect(function(input)
		if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then drag(input.Position) end
	end))
	Keep(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = nil end
	end))

	local RefreshOptions, RefreshColors, PaintGlass, Mark, SelectCat
	local activeCat, query = "KITS", ""

	-- ===== history =====
	local undo, redo = {}, {}
	local undoBtn, redoBtn
	local function PaintHistory()
		if undoBtn then undoBtn.TextTransparency = #undo > 0 and 0 or 0.65 end
		if redoBtn then redoBtn.TextTransparency = #redo > 0 and 0 or 0.65 end
	end
	PushUndo = function()
		table.insert(undo, Capture())
		if #undo > 80 then table.remove(undo, 1) end
		table.clear(redo)
		PaintHistory()
	end
	local function ApplyState(st)
		for k, v in pairs(st.cfg) do CK.Cfg[k] = v end
		for k, v in pairs(st.cols) do Themes.Custom[k] = v end
		CK.Custom = CloneTable(st.custom or CK.Custom)
		CK.NormalizeCustom()
		Prefs.GlassAlpha = st.glass
		CK.SyncTheme()
		RefreshOptions(); RefreshColors(); PaintGlass(); Mark()
	end
	local function Undo()
		if #undo == 0 then return end
		table.insert(redo, Capture())
		ApplyState(table.remove(undo))
		PaintHistory(); Say("undo")
	end
	local function Redo()
		if #redo == 0 then return end
		table.insert(undo, Capture())
		ApplyState(table.remove(redo))
		PaintHistory(); Say("redo")
	end

	-- ===== live preview (center) =====
	local toolbar = New("Frame", colC, {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1})
	New("TextLabel", toolbar, {Size = UDim2.fromOffset(110,22), BackgroundTransparency = 1, Text = "LIVE PREVIEW", TextColor3 = ACC, Font = GOTHB, TextSize = 11, TextXAlignment = LEFT})
	local tools = New("Frame", toolbar, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,0), Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1})
	New("UIListLayout", tools, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center})
	local toolBtns = {}
	local function ToolBtn(group, text, i, onClick)
		local b = Round(New("TextButton", tools, {Name = group .. "|" .. text, Size = UDim2.fromOffset(0,20), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = K_ROW, Text = text,
			TextColor3 = K_SUB, Font = GOTHB, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i}), 5)
		New("UIPadding", b, {PaddingLeft = UDim.new(0,7), PaddingRight = UDim.new(0,7)})
		toolBtns[group] = toolBtns[group] or {}
		toolBtns[group][text] = b
		b.MouseButton1Click:Connect(function() onClick(text) end)
		return b
	end
	local function PaintTools(group, current)
		for t, b in pairs(toolBtns[group] or {}) do
			b.BackgroundColor3 = t == current and ACC or K_ROW
			b.TextColor3 = t == current and K_BG or K_SUB
		end
	end

	local stage = Round(New("Frame", colC, {Position = UDim2.fromOffset(0,28), Size = UDim2.new(1,0,1,-54), BackgroundColor3 = Color3.fromRGB(8,8,11), BorderSizePixel = 0, ClipsDescendants = true}), 10)
	New("UIStroke", stage, {Color = K_LINE, Thickness = 1})
	local blobs = {}
	for _, bl in ipairs({{0.12, 0.2, 170, Color3.fromRGB(255,90,140)}, {0.84, 0.3, 210, Color3.fromRGB(70,160,255)}, {0.5, 0.9, 190, Color3.fromRGB(80,220,150)}}) do
		table.insert(blobs, Round(New("Frame", stage, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(bl[1], bl[2]), Size = UDim2.fromOffset(bl[3], bl[3]),
			BackgroundColor3 = bl[4], BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 1}), 100))
	end
	local stageShade = New("Frame", stage, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1})
	local zoomInfo = New("TextLabel", colC, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,0,1,0), Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "",
		TextColor3 = K_MUTE, Font = GOTHM, TextSize = 10, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
	local mockHolder = New("Frame", stage, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(760,480), BackgroundTransparency = 1, ZIndex = 2})
	local mockScale = New("UIScale", mockHolder, {Scale = 1})
	local mockB, mockConns, mockState = nil, {}, {}
	local zoom, bgMode = "AUTO", "BLOBS"

	local function UpdateMockScale()
		local cs = math.max(scale.Scale, 0.01)
		local ax, ay = stage.AbsoluteSize.X / cs, stage.AbsoluteSize.Y / cs
		local fit = math.min((ax - 16) / CK.Cfg.Width, (ay - 16) / CK.Cfg.Height)
		local s = zoom == "AUTO" and math.min(fit, 1) or (zoom == "100%" and 1 or (zoom == "75%" and 0.75 or 0.5))
		mockScale.Scale = math.clamp(s, 0.15, 1)
		local pct = math.floor(mockScale.Scale * 100 + 0.5)
		zoomInfo.Text = string.format("preview at %d%%%s  |  window %dx%d  |  glass slider = how much of the game shows through the panels", pct,
			(zoom == "100%" and mockScale.Scale > fit) and " (bigger than this area)" or "", CK.Cfg.Width, CK.Cfg.Height)
	end
	local function PaintStageBg()
		for _, b in ipairs(blobs) do b.Visible = bgMode == "BLOBS" end
		stage.BackgroundColor3 = bgMode == "LIGHT" and Color3.fromRGB(220,220,226) or Color3.fromRGB(8,8,11)
	end
	for i, z in ipairs({"AUTO", "100%", "75%", "50%"}) do ToolBtn("zoom", z, i, function(t) zoom = t; PaintTools("zoom", zoom); UpdateMockScale() end) end
	for i, m in ipairs({"BLOBS", "DARK", "LIGHT"}) do ToolBtn("bg", m, 10 + i, function(t) bgMode = t; PaintTools("bg", bgMode); PaintStageBg() end) end
	PaintTools("zoom", zoom); PaintTools("bg", bgMode); PaintStageBg()

	local function MockConnect(sig, fn) local cn = sig:Connect(fn); table.insert(mockConns, cn); return cn end
	local function MockLabel(parent, it, props)
		props.BackgroundTransparency = 1
		local t = New("TextLabel", parent, props)
		t.Text = it.raw or ""
		return t
	end
	local pend, pendPr = nil, -1
	local function MockTag(inst, cat, pr)
		inst.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
			if pr > pendPr then pend, pendPr = cat, pr end
			task.defer(function()
				if pend then local c = pend; pend, pendPr = nil, -1; SelectCat(c) end
			end)
		end)
	end
	local function PreviewTabs()
		CK.EnsureCustomTabs(PreviewTabKeys)
		local out = {}
		for _, def in ipairs(CK.Custom.Tabs) do
			if def.Visible ~= false then
				local isCustom = def.Custom == true
				local key = def.Key
				table.insert(out, {Key = key, items = isCustom and (def.Items or {}) or PreviewItems(key), label = function(parent, props)
					local t = New("TextLabel", parent, props)
					if def.Title and def.Title ~= "" then t.Text = def.Title else t.Text = Locale.T("TAB_" .. key) end
					return t
				end})
			end
		end
		return out
	end
	local previewLogic = {
		toggle = function(it, r, paint)
			local k = it.k or it.raw
			if mockState[k] == nil then mockState[k] = it.def == true end
			MockConnect(r.MouseButton1Click, function() mockState[k] = not mockState[k]; paint(mockState[k]) end)
			paint(mockState[k])
		end,
		slider = function(it, hit, track, paint)
			local k = "s:" .. (it.k or it.raw)
			local m = 10 ^ (it.dec or 0)
			local function show()
				local v = math.floor((it.min + (it.max - it.min) * mockState[k]) * m + 0.5) / m
				paint(mockState[k], tostring(v))
			end
			if mockState[k] == nil then mockState[k] = it.def or 0.5 end
			MockConnect(hit.InputBegan, function(input)
				BeginDrag(input, function(pos)
					mockState[k] = math.clamp((pos.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
					show()
				end, true)
			end)
			show()
		end,
		choice = function(it, b, paint)
			local k = "c:" .. (it.k or it.raw)
			if mockState[k] == nil then mockState[k] = 1 end
			local function show() paint(it.opts[mockState[k]]) end
			MockConnect(b.MouseButton1Click, function() mockState[k] = mockState[k] % #it.opts + 1; show() end)
			MockConnect(b.MouseButton2Click, function() mockState[k] = (mockState[k] - 2) % #it.opts + 1; show() end)
			show()
		end,
		bind = function(it, b, paint)
			local label = string.upper(it.key or "NONE")
			MockConnect(b.MouseButton1Click, function() paint("..."); task.delay(0.9, function() if b.Parent then paint(label) end end) end)
			paint(label)
		end,
		info = function(v, it) v.Text = it.val or "-" end,
		input = function(parent, it, props)
			local base = {Text = "", PlaceholderText = it.raw or "", PlaceholderColor3 = "@Muted", TextColor3 = "@Text", Font = CODE, TextSize = 11, ClearTextOnFocus = false, TextXAlignment = LEFT}
			for k, v in pairs(props) do base[k] = v end
			return New("TextBox", parent, base)
		end,
		avatar = function(parent, px)
			local img = Round(New("ImageLabel", parent, {Size = UDim2.fromOffset(px, px), BackgroundColor3 = "@Background", BorderSizePixel = 0, ScaleType = Enum.ScaleType.Crop}), 10)
			task.spawn(function()
				local ok, content, ready = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
				if ok and ready and img.Parent then img.Image = content end
			end)
			return img
		end,
	}
	local function BuildMock()
		for _, cn in ipairs(mockConns) do cn:Disconnect() end
		table.clear(mockConns)
		if mockB then mockB.Destroy(); mockB = nil end
		-- Rebuilding the live preview destroys old labels; discard their dead locale bindings now,
		-- not only after the next language switch.
		for i = #Locale.Registry, 1, -1 do
			local entry = Locale.Registry[i]
			local ok, parent = pcall(function() return entry.Instance and entry.Instance.Parent end)
			if not ok or parent == nil then table.remove(Locale.Registry, i) end
		end
		CK.SyncTheme()
		local cfg = {}
		for k, v in pairs(CK.Cfg) do cfg[k] = v end
		if CK.Custom.Effects and CK.Custom.Effects.Open then cfg.Open = CK.Custom.Effects.Open end
		local x = CK.Ctx(cfg, MockConnect, MockLabel, true, {tag = MockTag})
		mockHolder.Size = UDim2.fromOffset(cfg.Width, cfg.Height)
		mockB = CK.Build(x, mockHolder, {
			refreshers = {},
			title = {raw = "VORTEX"},
			tabs = PreviewTabs(),
			buildTab = function(e, page, C)
				local ctx = {page = page, n = 0}
				for i, sourceItem in ipairs(e.items or {}) do
					if type(sourceItem) == "table" then
						local it = {}
						for k, v in pairs(sourceItem) do it[k] = v end
						if it.raw == nil then it.raw = it.text or it.label or it.title or "" end
						local handler = type(it.t) == "string" and C[it.t] or nil
						if type(handler) == "function" then
							local ok, err = pcall(handler, it, ctx)
							if not ok then DebugLog.Push("preview", string.format("tab %s item %d: %s", tostring(e.Key), i, tostring(err)), true) end
						else
							DebugLog.Push("preview", string.format("tab %s has unsupported preview control '%s' at %d", tostring(e.Key), tostring(it.t), i), true)
						end
					end
				end
			end,
			logic = previewLogic,
			bindText = function(b, it) b.Text = it.raw or "" end,
			baseSub = function() return "BETA V8  |  " .. string.upper(LocalPlayer.Name) end,
			hintText = function() return "MENU KEY  RightShift" end,
			onLocale = function() end,
			tick = function(fn) MockConnect(RunService.Heartbeat, fn) end,
			onLog = function(s)
				for i, line in ipairs({"[system] hub init, skin = Custom", "[system] hub loaded successfully", "[config] preview log line", "[system] custom menu preview"}) do
					New("TextLabel", s, {Size = UDim2.new(1,0,0,14), BackgroundTransparency = 1, Text = line, TextColor3 = "@SubText", Font = CODE, TextSize = 10, TextXAlignment = LEFT, LayoutOrder = i})
				end
			end,
			collapse = function(h, group, chevron)
				local collapsed = false
				MockConnect(h.MouseButton1Click, function()
					collapsed = not collapsed
					group.Visible = not collapsed
					chevron.Rotation = collapsed and -90 or 0
				end)
			end,
			uiScale = 1, visible = true, backdrop = false,
			userName = LocalPlayer.Name, displayName = LocalPlayer.DisplayName,
		})
		x.snap = false
		stageShade.BackgroundTransparency = cfg.Backdrop == "Dim" and 0.45 or (cfg.Backdrop == "Dark" and 0.75 or 1)
		CK.GlassSnap()
		UpdateMockScale()
	end
	local dirty = false
	Mark = function()
		if dirty then return end
		dirty = true
		task.defer(function()
			dirty = false
			if gui.Parent then BuildMock() end
		end)
	end
	Keep(stage:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateMockScale))

	-- ===== brick box (left) =====
	local order = 0
	local function Next() order += 1; return order end
	local chipRefs, sliderRefs, textRefs, blocks, catChips = {}, {}, {}, {}, {}
	local function Relayout()
		local q = string.lower(query)
		for _, b in ipairs(blocks) do
			if q ~= "" then b.frame.Visible = string.find(string.lower(b.label), q, 1, true) ~= nil
			else b.frame.Visible = b.cat == activeCat end
		end
		for cat, b in pairs(catChips) do
			local on = q == "" and cat == activeCat
			b.BackgroundColor3 = on and ACC or K_ROW
			b.TextColor3 = on and K_BG or K_SUB
		end
	end
	RefreshOptions = function()
		for key, ref in pairs(chipRefs) do
			for opt, b in pairs(ref) do
				local on = CK.Cfg[key] == opt
				b.BackgroundColor3 = on and ACC or K_ROW
				b.TextColor3 = on and K_BG or K_SUB
			end
		end
		for _, ref in pairs(sliderRefs) do ref.paint() end
		for key, box in pairs(textRefs) do box.Text = CK.Cfg[key] end
	end
	local function Chip(parent, text, i, name)
		local b = Round(New("TextButton", parent, {Name = name, Size = UDim2.fromOffset(0,24), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = K_ROW, Text = text, TextColor3 = K_SUB,
			Font = GOTHB, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i}), 6)
		New("UIPadding", b, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
		return b
	end
	local function Wrap(parent, orderN)
		local row = New("Frame", parent, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = orderN})
		New("UIListLayout", row, {FillDirection = Enum.FillDirection.Horizontal, Wraps = true, Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder})
		return row
	end
	local function Block(cat, label, name)
		local blk = New("Frame", colL, {Name = name, Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = Next(), Visible = false})
		New("UIListLayout", blk, {Padding = UDim.new(0,5), SortOrder = Enum.SortOrder.LayoutOrder})
		table.insert(blocks, {frame = blk, cat = cat, label = label})
		return blk
	end
	local function HeadRow(blk, o, valueWidget)
		local head = New("Frame", blk, {Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, LayoutOrder = 1})
		New("TextLabel", head, {Size = UDim2.new(1,-90,1,0), BackgroundTransparency = 1, Text = o.label, TextColor3 = K_SUB, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, TextTruncate = Enum.TextTruncate.AtEnd})
		local rst = Round(New("TextButton", head, {Name = "reset|" .. o.key, AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,1), Size = UDim2.fromOffset(38,16), BackgroundColor3 = K_ROW,
			Text = "reset", TextColor3 = K_MUTE, Font = GOTHM, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0}), 4)
		rst.MouseButton1Click:Connect(function()
			if CK.Cfg[o.key] == o.def then return end
			PushUndo(); CK.Cfg[o.key] = o.def; RefreshOptions(); Mark()
		end)
		return head
	end
	local function MakeChoice(o)
		local blk = Block(o.cat, o.label, "block|" .. o.key)
		HeadRow(blk, o)
		local row = Wrap(blk, 2)
		chipRefs[o.key] = {}
		for i, opt in ipairs(o.opts) do
			local b = Chip(row, opt, i, "chip|" .. o.key .. "|" .. opt)
			chipRefs[o.key][opt] = b
			b.MouseButton1Click:Connect(function()
				if CK.Cfg[o.key] == opt then return end
				PushUndo(); CK.Cfg[o.key] = opt; RefreshOptions(); Mark()
			end)
		end
	end
	local function MakeSlider(o)
		local blk = Block(o.cat, o.label, "slider|" .. o.key)
		local head = HeadRow(blk, o)
		local val = Round(New("TextBox", head, {Name = "val|" .. o.key, AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-44,0,0), Size = UDim2.fromOffset(44,18), BackgroundColor3 = K_ROW, Text = "",
			TextColor3 = K_TEXT, Font = GOTHB, TextSize = 11, ClearTextOnFocus = true, BorderSizePixel = 0}), 4)
		local hit = New("Frame", blk, {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1, LayoutOrder = 2})
		local track = Round(New("Frame", hit, {AnchorPoint = Vector2.new(0,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.new(1,0,0,6), BackgroundColor3 = K_ROW, BorderSizePixel = 0}), 3)
		local fill = Round(New("Frame", track, {Size = UDim2.fromScale(0,1), BackgroundColor3 = ACC, BorderSizePixel = 0}), 3)
		local knob = Round(New("Frame", track, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.fromOffset(12,12), BackgroundColor3 = K_TEXT, BorderSizePixel = 0, ZIndex = 2}), 100)
		local function paint()
			local a = (CK.Cfg[o.key] - o.min) / (o.max - o.min)
			fill.Size = UDim2.fromScale(a, 1)
			knob.Position = UDim2.fromScale(a, 0.5)
			val.Text = tostring(CK.Cfg[o.key])
		end
		local function fromPos(pos)
			local a = math.clamp((pos.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			local v = o.min + math.floor((o.max - o.min) * a / o.step + 0.5) * o.step
			CK.Cfg[o.key] = math.clamp(v, o.min, o.max)
			paint(); Mark()
		end
		sliderRefs[o.key] = {paint = paint}
		hit.InputBegan:Connect(function(input) BeginDrag(input, fromPos) end)
		val.FocusLost:Connect(function()
			local n = tonumber(val.Text)
			if n then
				PushUndo()
				n = o.min + math.floor((math.clamp(n, o.min, o.max) - o.min) / o.step + 0.5) * o.step
				CK.Cfg[o.key] = math.clamp(n, o.min, o.max)
				Mark()
			end
			paint()
		end)
		paint()
	end
	local function MakeText(o)
		local blk = Block(o.cat, o.label, "text|" .. o.key)
		HeadRow(blk, o)
		local box = Round(New("TextBox", blk, {Name = "textbox|" .. o.key, Size = UDim2.new(1,0,0,28), BackgroundColor3 = K_ROW, Text = "", PlaceholderText = "default", PlaceholderColor3 = K_MUTE,
			TextColor3 = K_TEXT, Font = CODE, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0, TextXAlignment = LEFT, LayoutOrder = 2}), 6)
		New("UIPadding", box, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
		textRefs[o.key] = box
		box.FocusLost:Connect(function()
			local v = CK.Clip(box.Text, o.max)
			if v ~= CK.Cfg[o.key] then PushUndo(); CK.Cfg[o.key] = v; Mark() end
			box.Text = CK.Cfg[o.key]
		end)
	end

	local function ApplyPalette(name)
		for _, pr in ipairs(BuilderPresets) do
			if pr[1] == name then
				for i, k in ipairs(ThemeKeys) do Themes.Custom[k] = Color3.fromRGB(table.unpack(pr[i + 1])) end
				return
			end
		end
	end
	local function ApplyKit(kit)
		PushUndo()
		CK.Reset()
		for k, v in pairs(kit.cfg) do CK.Cfg[k] = v end
		if kit.pal then ApplyPalette(kit.pal) end
		Prefs.GlassAlpha = kit.glass or 0
		CK.SyncTheme()
		RefreshOptions(); RefreshColors(); PaintGlass(); Mark()
		Say("kit: " .. kit.name)
	end
	local function ImportCode(code)
		local ok, cfg, cols, glass, custom = CK.Import(code)
		if not ok then Say("not a valid share code"); return false end
		PushUndo()
		CK.Reset(); CK.ParseCfg(cfg)
		for k, v in pairs(cols) do Themes.Custom[k] = v end
		if custom then CK.Custom = custom end
		CK.NormalizeCustom()
		Prefs.GlassAlpha = glass
		CK.SyncTheme()
		RefreshOptions(); RefreshColors(); PaintGlass(); Mark()
		return true
	end

	-- search + category chips
	local searchBox = Round(New("TextBox", colL, {Name = "search", Size = UDim2.new(1,0,0,28), BackgroundColor3 = K_ROW, Text = "", PlaceholderText = "search options...", PlaceholderColor3 = K_MUTE,
		TextColor3 = K_TEXT, Font = GOTHM, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0, TextXAlignment = LEFT, LayoutOrder = Next()}), 7)
	New("UIPadding", searchBox, {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
	local catRow = Wrap(colL, Next())
	for i, cat in ipairs(CK.Cats) do
		local b = Chip(catRow, cat, i, "cat|" .. cat)
		catChips[cat] = b
		b.MouseButton1Click:Connect(function() SelectCat(cat) end)
	end
	SelectCat = function(cat)
		activeCat = cat
		query = ""
		if searchBox.Text ~= "" then searchBox.Text = "" end
		Relayout()
		colL.CanvasPosition = Vector2.new(0, 0)
		Say("editing: " .. cat)
	end
	searchBox:GetPropertyChangedSignal("Text"):Connect(function() query = searchBox.Text; Relayout() end)

	-- KITS: starter kits, 3 save slots, share code
	do
		local blk = Block("KITS", "starter kits presets one click", "block|kits")
		New("TextLabel", blk, {Size = UDim2.new(1,0,0,14), BackgroundTransparency = 1, Text = "STARTER KITS  (one click = every brick + palette)", TextColor3 = K_SUB, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, LayoutOrder = 1})
		local row = Wrap(blk, 2)
		for i, kit in ipairs(CK.Kits) do
			local b = Chip(row, kit.name, i, "kit|" .. kit.name)
			b.TextColor3 = K_TEXT
			b.MouseButton1Click:Connect(function() ApplyKit(kit) end)
		end

		local sb = Block("KITS", "save slots my designs load", "block|slots")
		New("TextLabel", sb, {Size = UDim2.new(1,0,0,14), BackgroundTransparency = 1, Text = "MY SLOTS  (whole design: bricks + colors + glass)", TextColor3 = K_SUB, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, LayoutOrder = 1})
		local slotLabels = {}
		local function PaintSlots()
			for n, l in pairs(slotLabels) do
				local used = LoadSetting("custom_slot_" .. n, "") ~= ""
				l.Text = used and ("SLOT " .. n .. "  (saved)") or ("SLOT " .. n .. "  (empty)")
				l.TextColor3 = used and K_TEXT or K_MUTE
			end
		end
		for n = 1, 3 do
			local r = New("Frame", sb, {Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1, LayoutOrder = 1 + n})
			slotLabels[n] = New("TextLabel", r, {Size = UDim2.new(1,-130,1,0), BackgroundTransparency = 1, Text = "", TextColor3 = K_MUTE, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT})
			local sv = Round(New("TextButton", r, {Name = "slotsave|" .. n, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-62,0.5,0), Size = UDim2.fromOffset(56,22), BackgroundColor3 = K_ROW,
				Text = "SAVE", TextColor3 = K_TEXT, Font = GOTHB, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0}), 5)
			local ld = Round(New("TextButton", r, {Name = "slotload|" .. n, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,0,0.5,0), Size = UDim2.fromOffset(56,22), BackgroundColor3 = K_ROW,
				Text = "LOAD", TextColor3 = K_TEXT, Font = GOTHB, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0}), 5)
			sv.MouseButton1Click:Connect(function()
				SaveSetting("custom_slot_" .. n, CK.Export(Themes.Custom, Prefs.GlassAlpha)); PaintSlots(); Say("saved to slot " .. n)
			end)
			ld.MouseButton1Click:Connect(function()
				local raw = LoadSetting("custom_slot_" .. n, "")
				if raw == "" then Say("slot " .. n .. " is empty") elseif ImportCode(raw) then Say("loaded slot " .. n) end
			end)
		end
		PaintSlots()

		local cb = Block("KITS", "share code export import copy paste", "block|code")
		New("TextLabel", cb, {Size = UDim2.new(1,0,0,14), BackgroundTransparency = 1, Text = "SHARE CODE  (send your design to a friend)", TextColor3 = K_SUB, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, LayoutOrder = 1})
		local codeBox = Round(New("TextBox", cb, {Name = "codebox", Size = UDim2.new(1,0,0,28), BackgroundColor3 = K_ROW, Text = "", PlaceholderText = "paste a code here", PlaceholderColor3 = K_MUTE,
			TextColor3 = K_TEXT, Font = CODE, TextSize = 11, ClearTextOnFocus = false, BorderSizePixel = 0, TextXAlignment = LEFT, LayoutOrder = 2}), 6)
		New("UIPadding", codeBox, {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8)})
		local crow = Wrap(cb, 3)
		local exp = Chip(crow, "EXPORT / COPY", 1, "codeexport"); exp.TextColor3 = K_TEXT
		local imp = Chip(crow, "IMPORT", 2, "codeimport"); imp.TextColor3 = K_TEXT
		exp.MouseButton1Click:Connect(function()
			local code = CK.Export(Themes.Custom, Prefs.GlassAlpha)
			codeBox.Text = code
			local ok = pcall(function() setclipboard(code) end)
			Say(ok and "code copied to clipboard" or "code is in the box, copy it from there")
		end)
		imp.MouseButton1Click:Connect(function() if ImportCode(codeBox.Text) then Say("design imported") end end)
	end
	-- ===== ADVANCED MENU DESIGNER =====
	CK.EnsureCustomTabs(PreviewTabKeys)
	local advancedBlock = Block("ADVANCED", "full custom menu system: widgets + event FX stacks + cursor + transitions + actions", "block|advanced")
	New("TextLabel", advancedBlock, {Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, Text = "ADVANCED MENU DESIGNER\nEvery interactive element can have stacked click / hover / press / release FX. Tab, menu open/close, cursor and sound effects are configurable too. Edit the full JSON when you need total freedom.", TextColor3 = K_SUB, Font = GOTHM, TextSize = 10, TextWrapped = true, TextXAlignment = LEFT, LayoutOrder = 1})

	local FX_CATALOG = {
		"None","Ripple","RippleSoft","RippleWide","RippleDouble","HaloRing","RingBurst","RingBurstWide",
		"Pulse","PulseSoft","PulseHard","Glow","GlowPulse","BorderPulse","Neon","Aura","UnderGlow",
		"Flash","FlashWhite","FlashAccent","Compress","Squash","Stretch","Bounce","Pop","Overshoot","Elastic","Spring","Snappy",
		"Lift","Float","FloatSoft","HoverUp","HoverDown","Magnetic",
		"Shake","ShakeSoft","ShakeHard","Jitter","Wobble","Tilt","TiltLeft","TiltRight",
		"Spin","SpinFast","SpinReverse","Orbit","Expand","Grow","Shrink","Jelly","Heartbeat","Breath",
		"Shine","Sweep","Glint","Scanline","Spotlight","Meteor","ColorPulse","Rainbow","HueSweep",
		"CornerPulse","CornerFlash","StarBurst","ParticleBurst","ParticleRain","Spark","DotBurst","Confetti",
		"SlideLeft","SlideRight","SlideUp","SlideDown","DriftLeft","DriftRight",
		"Echo","Ghost","AfterImage","Flicker","FlickerSoft","Glitch","Chromatic",
		"FadeIn","FadeOut","FadeOutIn","Dim","FadeToNormal","Reset"
	}
	local FX_PRESETS = {
		{name="Neon", Click={"Ripple","GlowPulse","RingBurst"}, Hover={"Glow","Lift","Shine"}, Press={"Compress","Tilt"}, Release={"Bounce"}, Open={"Pop","Shine"}, Tab={"Slide","GlowPulse"}, TabHover={"Glow"}},
		{name="Cinematic", Click={"Flash","Expand","HaloRing"}, Hover={"Glow","Shine","Spotlight"}, Press={"Compress"}, Release={"Elastic","FadeToNormal"}, Open={"FadeToNormal","Pop","Shine"}, Tab={"Slide","Shine"}, TabHover={"Shine"}},
		{name="Soft", Click={"RippleSoft","PulseSoft"}, Hover={"Glow","Lift","Breath"}, Press={"Compress"}, Release={"Bounce"}, Open={"FadeToNormal"}, Tab={"Pop"}, TabHover={"Glow"}},
		{name="Arcade", Click={"FlashAccent","Jelly","Confetti"}, Hover={"GlowPulse","Wobble","Shine"}, Press={"Compress","ShakeSoft"}, Release={"Bounce","Spin"}, Open={"Pop","FlashAccent"}, Tab={"Pop","StarBurst"}, TabHover={"Pulse"}},
		{name="Glass", Click={"RippleWide","GlowPulse","Echo"}, Hover={"Aura","Lift","Shine"}, Press={"Compress"}, Release={"Spring"}, Open={"FadeIn","Aura"}, Tab={"Slide","Glow"}, TabHover={"Aura"}},
		{name="Minimal", Click={"RippleSoft"}, Hover={"UnderGlow"}, Press={"Squash"}, Release={"Spring"}, Open={"FadeIn"}, Tab={"SlideLeft"}, TabHover={"UnderGlow"}},
		{name="Futuristic", Click={"RingBurstWide","Scanline","FlashAccent"}, Hover={"Neon","Magnetic","Glint"}, Press={"Compress","Tilt"}, Release={"Spring"}, Open={"SlideRight","Shine"}, Tab={"SlideRight","Scanline"}, TabHover={"Glint"}},
		{name="Energy", Click={"StarBurst","ParticleBurst","PulseHard"}, Hover={"Aura","Heartbeat","Rainbow"}, Press={"Compress","Jitter"}, Release={"Bounce","SpinFast"}, Open={"Pop","StarBurst"}, Tab={"SlideUp","ParticleBurst"}, TabHover={"PulseHard"}},
		{name="Premium", Click={"Ripple","HaloRing","Shine"}, Hover={"Glow","Magnetic","Spotlight"}, Press={"Compress","Tilt"}, Release={"Spring"}, Open={"FadeIn","Shine"}, Tab={"Slide","Aura"}, TabHover={"Spotlight"}},
		{name="Chaos", Click={"RippleDouble","ParticleBurst","ShakeHard","Flash"}, Hover={"Neon","Wobble","Rainbow","Jitter"}, Press={"Compress","Tilt","Shake"}, Release={"Elastic","SpinFast"}, Open={"Spin","Flash","Confetti"}, Tab={"SlideLeft","Jelly","StarBurst"}, TabHover={"ShakeSoft","Glow"}},
	}
	local function FxText(v)
		if type(v) == "table" then return table.concat(v, ", ") end
		return tostring(v or "")
	end
	local function ParseFxText(s)
		local out = {}
		for token in string.gmatch(tostring(s or ""), "[^,%+>]+") do
			token = string.gsub(token, "^%s+", ""); token = string.gsub(token, "%s+$", "")
			if token ~= "" and token ~= "None" then out[#out+1] = token end
		end
		return #out == 0 and "None" or (#out == 1 and out[1] or out)
	end
	local fxBoxes = {}
	local function FXBox(label, key, order)
		local row = New("Frame", advancedBlock, {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, LayoutOrder = order})
		New("TextLabel", row, {Size = UDim2.fromOffset(72,30), BackgroundTransparency = 1, Text = label, TextColor3 = K_SUB, Font = GOTHB, TextSize = 10, TextXAlignment = LEFT})
		local box = Round(New("TextBox", row, {Position = UDim2.fromOffset(76,0), Size = UDim2.new(1,-76,0,30), BackgroundColor3 = K_ROW, Text = FxText(CK.Custom.Effects[key]), PlaceholderText = "None", PlaceholderColor3 = K_MUTE, TextColor3 = K_TEXT, Font = CODE, TextSize = 10, ClearTextOnFocus = false, BorderSizePixel = 0, TextXAlignment = LEFT}), 6)
		New("UIPadding", box, {PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8)})
		box.FocusLost:Connect(function() CK.Custom.Effects[key] = ParseFxText(box.Text); Mark() end)
		fxBoxes[key] = box
		return box
	end
	FXBox("CLICK", "Click", 2); FXBox("HOVER", "Hover", 3); FXBox("PRESS", "Press", 4); FXBox("RELEASE", "Release", 5)
	FXBox("TAB", "Tab", 6); FXBox("TAB HOVER", "TabHover", 7); FXBox("OPEN FX", "OpenExtra", 8); FXBox("CLOSE FX", "Close", 9); FXBox("RIGHT CLICK", "RightClick", 10)
	local studioLabel = New("TextLabel", advancedBlock, {Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, Text="MOTION STUDIO", TextColor3=ACC, Font=GOTHB, TextSize=11, TextXAlignment=LEFT, LayoutOrder=11})
	local studioRow1 = Wrap(advancedBlock, 12)
	local function MotionMini(label,key,width)
		local box=Round(New("TextBox",studioRow1,{Size=UDim2.fromOffset(width or 90,28),BackgroundColor3=K_ROW,Text=tostring(CK.Custom.Effects[key] or ""),PlaceholderText=label,PlaceholderColor3=K_MUTE,TextColor3=K_TEXT,Font=CODE,TextSize=10,ClearTextOnFocus=false,BorderSizePixel=0}),6)
		New("UIPadding",box,{PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)})
		box.FocusLost:Connect(function() local n=tonumber(box.Text); if n then CK.Custom.Effects[key]=n; CK.NormalizeCustom(); Mark() end; box.Text=tostring(CK.Custom.Effects[key] or "") end)
		return box
	end
	MotionMini("DURATION","Duration",92); MotionMini("SPEED","Speed",82); MotionMini("HOVER SCALE","HoverScale",92); MotionMini("PRESS SCALE","PressScale",92)
	local studioRow2 = Wrap(advancedBlock, 13)
	MotionMini("HOVER LIFT","HoverLift",92); MotionMini("HOVER ROT","HoverRotation",92); MotionMini("STAGGER","Stagger",82)
	local reduceChip=Chip(studioRow2,CK.Custom.Effects.ReduceMotion and "REDUCED" or "FULL MOTION",10,"reduceMotion"); reduceChip.TextColor3=K_TEXT
	reduceChip.MouseButton1Click:Connect(function() CK.Custom.Effects.ReduceMotion=not CK.Custom.Effects.ReduceMotion; reduceChip.Text=CK.Custom.Effects.ReduceMotion and "REDUCED" or "FULL MOTION"; Mark() end)
	local smoothChip=Chip(studioRow2,CK.Custom.Effects.SmoothTransitions==false and "SNAP" or "SMOOTH",11,"smoothTransitions"); smoothChip.TextColor3=K_TEXT
	smoothChip.MouseButton1Click:Connect(function() CK.Custom.Effects.SmoothTransitions=CK.Custom.Effects.SmoothTransitions==false; smoothChip.Text=CK.Custom.Effects.SmoothTransitions==false and "SNAP" or "SMOOTH"; Mark() end)
	local presetRow = Wrap(advancedBlock, 14)
	New("TextLabel", presetRow, {Size = UDim2.fromOffset(50,26), BackgroundTransparency = 1, Text = "PRESETS", TextColor3 = ACC, Font = GOTHB, TextSize = 9, TextXAlignment = LEFT})
	for i, p in ipairs(FX_PRESETS) do
		local b = Chip(presetRow, p.name, i+1, "fxpreset|"..p.name); b.TextColor3 = K_TEXT
		b.MouseButton1Click:Connect(function()
			for _, k in ipairs({"Click","Hover","Press","Release","Open","Close","Tab","TabHover"}) do
				if p[k] then if k == "Open" then CK.Custom.Effects.OpenExtra = p[k] else CK.Custom.Effects[k] = p[k] end end
			end
			for k, box in pairs(fxBoxes) do box.Text = FxText(CK.Custom.Effects[k]) end
			Mark(); Say("FX preset: " .. p.name)
		end)
	end
	local catalog = Round(New("TextLabel", advancedBlock, {Size = UDim2.new(1,0,0,46), BackgroundColor3 = K_BG, Text = "EFFECT LIBRARY  |  " .. table.concat(FX_CATALOG, "  •  "), TextColor3 = K_MUTE, Font = CODE, TextSize = 8, TextWrapped = true, TextXAlignment = LEFT, TextYAlignment = TOP, LayoutOrder = 15, BorderSizePixel = 0}), 6)
	New("UIPadding", catalog, {PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,6)})

	local miscRow = Wrap(advancedBlock, 16)
	local function mini(label, val, setter, width)
		local box = Round(New("TextBox", miscRow, {Size = UDim2.fromOffset(width or 105,28), BackgroundColor3 = K_ROW, Text = tostring(val or ""), PlaceholderText = label, PlaceholderColor3 = K_MUTE, TextColor3 = K_TEXT, Font = CODE, TextSize = 10, ClearTextOnFocus = false, BorderSizePixel = 0}), 6)
		New("UIPadding", box,{PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)})
		box.FocusLost:Connect(function() setter(box.Text); Mark() end)
		return box
	end
	mini("duration", CK.Custom.Effects.Duration, function(v) CK.Custom.Effects.Duration=tonumber(v) or 0.18 end)
	mini("speed", CK.Custom.Effects.Speed, function(v) CK.Custom.Effects.Speed=tonumber(v) or 1 end)
	mini("color #RRGGBB", CK.Custom.Effects.Color, function(v) CK.Custom.Effects.Color=CK.Clip(v,7) end)
	mini("color2 #RRGGBB", CK.Custom.Effects.Color2, function(v) CK.Custom.Effects.Color2=CK.Clip(v,7) end)
	mini("click sound", CK.Custom.Effects.ClickSound, function(v) CK.Custom.Effects.ClickSound=CK.Clip(v,180) end, 125)
	mini("volume 0-1", CK.Custom.Effects.Volume, function(v) CK.Custom.Effects.Volume=tonumber(v) or 0.55 end, 90)

	local fxJson = Round(New("TextBox", advancedBlock, {Name="fx_json", Size=UDim2.new(1,0,0,92), BackgroundColor3=K_BG, Text=HttpService:JSONEncode(CK.Custom.Effects), PlaceholderText="advanced Effects JSON...", PlaceholderColor3=K_MUTE, TextColor3=K_TEXT, Font=CODE, TextSize=9, ClearTextOnFocus=false, MultiLine=true, TextWrapped=false, BorderSizePixel=0, TextXAlignment=LEFT, TextYAlignment=TOP, LayoutOrder=15}),6)
	New("UIPadding", fxJson,{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,6)})
	local fxJsonRow = Wrap(advancedBlock, 16)
	local fxJsonExport = Chip(fxJsonRow,"COPY EFFECTS JSON",1,"fxjsoncopy"); fxJsonExport.TextColor3=K_TEXT
	local fxJsonImport = Chip(fxJsonRow,"IMPORT EFFECTS JSON",2,"fxjsonimport"); fxJsonImport.TextColor3=K_TEXT
	fxJsonExport.MouseButton1Click:Connect(function() fxJson.Text=HttpService:JSONEncode(CK.Custom.Effects); local ok=pcall(function() setclipboard(fxJson.Text) end); Say(ok and "effects JSON copied" or "effects JSON placed in box") end)
	fxJsonImport.MouseButton1Click:Connect(function() local ok,data=pcall(HttpService.JSONDecode,HttpService,fxJson.Text); if ok and type(data)=="table" then CK.Custom.Effects=data; CK.NormalizeCustom(); for k,b in pairs(fxBoxes) do b.Text=FxText(CK.Custom.Effects[k]) end; Mark(); Say("effects imported") else Say("invalid effects JSON") end end)

	local itemHelp = Round(New("TextLabel", advancedBlock, {Size=UDim2.new(1,0,0,88), BackgroundColor3=K_BG, Text="PER-ELEMENT FX\nAdd this to any widget in the MENU JSON:\n{\"events\":{\"hoverEnter\":{\"effects\":[\"Glow\",\"Lift\"]},\"press\":{\"effects\":[\"Compress\",\"Tilt\"]},\"release\":{\"effects\":[\"Bounce\"]},\"click\":{\"effects\":[\"Ripple\",\"ParticleBurst\"],\"action\":\"Notify\",\"notify\":\"clicked\"}}}\nYou can also use duration, speed, color, color2, size, easing, direction and sound on each event.", TextColor3=K_MUTE, Font=CODE, TextSize=8, TextWrapped=true, TextXAlignment=LEFT, TextYAlignment=TOP, LayoutOrder=17, BorderSizePixel=0}),6)
	New("UIPadding", itemHelp,{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,6)})

	local jsonBox = Round(New("TextBox", advancedBlock, {Name = "menu_definition", Size = UDim2.new(1,0,0,160), BackgroundColor3 = K_BG, Text = CK.CustomCode(), PlaceholderText = "full custom menu JSON...", PlaceholderColor3 = K_MUTE, TextColor3 = K_TEXT, Font = CODE, TextSize = 9, ClearTextOnFocus = false, MultiLine = true, TextWrapped = false, BorderSizePixel = 0, TextXAlignment = LEFT, TextYAlignment = TOP, LayoutOrder = 18}), 6)
	New("UIPadding", jsonBox, {PaddingLeft = UDim.new(0,9), PaddingRight = UDim.new(0,9), PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8)})
	local jsonRow = Wrap(advancedBlock, 19)
	local jsonExport = Chip(jsonRow, "EXPORT FULL JSON", 1, "jsonexport"); jsonExport.TextColor3 = K_TEXT
	local jsonImport = Chip(jsonRow, "IMPORT FULL JSON", 2, "jsonimport"); jsonImport.TextColor3 = K_TEXT
	local jsonReset = Chip(jsonRow, "RESET MENU DESIGN", 3, "jsonreset"); jsonReset.TextColor3 = K_TEXT
	local tabLabel = New("TextLabel", advancedBlock, {Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, Text = "CUSTOM TABS", TextColor3 = ACC, Font = GOTHB, TextSize = 11, TextXAlignment = LEFT, LayoutOrder = 20})
	local tabList = New("Frame", advancedBlock, {Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 21})
	New("UIListLayout", tabList, {Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder})
	local addTab = Chip(Wrap(advancedBlock, 22), "+ ADD CUSTOM TAB", 1, "addcustomtab"); addTab.TextColor3 = K_TEXT
	local function PaintAdvancedTabs()
		for _, child in ipairs(tabList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
		for i, t in ipairs(CK.Custom.Tabs) do
			local row = New("Frame", tabList, {Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, LayoutOrder=i})
			local name = Round(New("TextBox", row, {Size=UDim2.new(1,-120,1,0), BackgroundColor3=K_ROW, Text=(t.Title~="" and t.Title or t.Key), TextColor3=K_TEXT, Font=GOTHM, TextSize=10, ClearTextOnFocus=false, BorderSizePixel=0, TextXAlignment=LEFT}),5)
			New("UIPadding",name,{PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)}); name.FocusLost:Connect(function() t.Title=CK.Clip(name.Text,32); Mark() end)
			local vis=Chip(row,t.Visible==false and "HIDDEN" or "VISIBLE",1,"tabvis|"..t.Key); vis.Position=UDim2.new(1,-112,0,1); vis.AnchorPoint=Vector2.new(0,0); vis.TextColor3=t.Visible==false and K_MUTE or K_TEXT
			vis.MouseButton1Click:Connect(function() t.Visible=t.Visible==false; PaintAdvancedTabs(); Mark() end)
			local edit=Chip(row,"EDIT",2,"tabedit|"..t.Key); edit.Position=UDim2.new(1,-112,0,1); edit.AnchorPoint=Vector2.new(0,0); edit.TextColor3=K_TEXT
			edit.MouseButton1Click:Connect(function() LoadTabEditor(t); Say("editing tab: "..t.Key) end)
			local del=Chip(row,t.Custom and "DEL" or "BASE",3,"tabdel|"..t.Key); del.Position=UDim2.new(1,-52,0,1); del.AnchorPoint=Vector2.new(0,0); del.TextColor3=t.Custom and Color3.fromRGB(255,100,110) or K_MUTE
			if t.Custom then del.MouseButton1Click:Connect(function() for j,q in ipairs(CK.Custom.Tabs) do if q==t then table.remove(CK.Custom.Tabs,j); break end end; if selectedCustomTab==t then selectedCustomTab=nil; tabJsonBox.Text="" end; PaintAdvancedTabs(); Mark() end) end
		end
	end
	local tabEditorLabel = New("TextLabel", advancedBlock, {Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, Text="TAB / ELEMENT LAB", TextColor3=ACC, Font=GOTHB, TextSize=11, TextXAlignment=LEFT, LayoutOrder=23})
	local tabEditorHint = New("TextLabel", advancedBlock, {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Text="Edit a whole tab directly: title, visibility, widget types, bindings, actions, sequences and per-event FX stacks.", TextColor3=K_MUTE, Font=GOTHM, TextSize=9, TextWrapped=true, TextXAlignment=LEFT, LayoutOrder=24})
	local selectedCustomTab=nil
	local tabJsonBox=Round(New("TextBox",advancedBlock,{Name="selected_tab_json",Size=UDim2.new(1,0,0,140),BackgroundColor3=K_BG,Text="",PlaceholderText="click EDIT on a tab above...",PlaceholderColor3=K_MUTE,TextColor3=K_TEXT,Font=CODE,TextSize=9,ClearTextOnFocus=false,MultiLine=true,TextWrapped=false,BorderSizePixel=0,TextXAlignment=LEFT,TextYAlignment=TOP,LayoutOrder=25}),6)
	New("UIPadding",tabJsonBox,{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,7),PaddingBottom=UDim.new(0,7)})
	local tabLabRow=Wrap(advancedBlock,26)
	local tabApply=Chip(tabLabRow,"APPLY TAB JSON",1,"applytabjson"); tabApply.TextColor3=K_TEXT
	local tabCopy=Chip(tabLabRow,"COPY TAB JSON",2,"copytabjson"); tabCopy.TextColor3=K_TEXT
	local tabAddItem=Chip(tabLabRow,"+ ITEM",3,"additemjson"); tabAddItem.TextColor3=K_TEXT
	local tabClear=Chip(tabLabRow,"CLEAR ITEMS",4,"clearitemjson"); tabClear.TextColor3=K_TEXT
	local function LoadTabEditor(tab) selectedCustomTab=tab; if tab then tabJsonBox.Text=HttpService:JSONEncode(tab) end end
	tabApply.MouseButton1Click:Connect(function() if not selectedCustomTab then Say("select a tab first"); return end; local ok,data=pcall(HttpService.JSONDecode,HttpService,tabJsonBox.Text); if ok and type(data)=="table" then PushUndo(); for k in pairs(selectedCustomTab) do selectedCustomTab[k]=nil end; for k,v in pairs(data) do selectedCustomTab[k]=v end; CK.NormalizeCustom(); PaintAdvancedTabs(); Mark(); Say("tab JSON applied") else Say("invalid tab JSON") end end)
	tabCopy.MouseButton1Click:Connect(function() if not selectedCustomTab then Say("select a tab first"); return end; local raw=HttpService:JSONEncode(selectedCustomTab); tabJsonBox.Text=raw; local ok=pcall(function() setclipboard(raw) end); Say(ok and "tab JSON copied" or "tab JSON ready") end)
	tabAddItem.MouseButton1Click:Connect(function() if not selectedCustomTab then Say("select a tab first"); return end; selectedCustomTab.Items=type(selectedCustomTab.Items)=="table" and selectedCustomTab.Items or {}; selectedCustomTab.Items[#selectedCustomTab.Items+1]={t="button",text="NEW ITEM",events={hoverEnter={effects={"Glow","Magnetic","Shine"}},press={effects={"Compress"}},release={effects={"Spring"}},click={effects={"Ripple","RingBurst","FlashAccent"},action="Notify",value="clicked"}}}; LoadTabEditor(selectedCustomTab); Mark(); Say("item added") end)
	tabClear.MouseButton1Click:Connect(function() if not selectedCustomTab then Say("select a tab first"); return end; selectedCustomTab.Items={}; LoadTabEditor(selectedCustomTab); Mark(); Say("items cleared") end)
	PaintAdvancedTabs()
	addTab.MouseButton1Click:Connect(function()
		local n=1
		while true do local key="CUSTOM_"..n; local found=false; for _,t in ipairs(CK.Custom.Tabs) do if t.Key==key then found=true end end; if not found then CK.Custom.Tabs[#CK.Custom.Tabs+1]={Key=key,Title="Custom "..n,Visible=true,Custom=true,Items={{t="section",text="CUSTOM"},{t="label",text="Build controls, transitions and FX per element"},{t="button",text="OPEN AIMBOT",action="OpenTab",target="AIMBOT",events={hoverEnter={effects={"Glow","Magnetic","Shine"}},press={effects={"Compress"}},release={effects={"Spring"}},click={effects={"Ripple","RingBurst","FlashAccent"}}}}}}; break end; n+=1 end
		PaintAdvancedTabs(); Mark(); Say("custom tab added")
	end)
	jsonExport.MouseButton1Click:Connect(function() jsonBox.Text=CK.CustomCode(); local ok=pcall(function() setclipboard(jsonBox.Text) end); Say(ok and "full menu JSON copied" or "JSON placed in the box") end)
	jsonImport.MouseButton1Click:Connect(function() local ok,data=pcall(HttpService.JSONDecode,HttpService,jsonBox.Text); if ok and type(data)=="table" then PushUndo(); CK.Custom=data; CK.NormalizeCustom(); CK.EnsureCustomTabs(PreviewTabKeys); for k,b in pairs(fxBoxes) do b.Text=FxText(CK.Custom.Effects[k]) end; PaintAdvancedTabs(); Mark(); Say("full menu JSON imported") else Say("invalid JSON") end end)
	jsonReset.MouseButton1Click:Connect(function()
		PushUndo(); CK.Custom={Version=5,Effects={Click={"Ripple","Pulse"},Hover={"Glow","Lift","Shine"},Press={"Compress"},Release={"Bounce"},RightClick={"RippleSoft","Echo"},Open="Pop",OpenExtra={"Pop","Shine"},Close={"FadeOutIn"},Tab={"Slide","Pop"},TabHover={"Glow"},Duration=0.18,Color="FFFFFF",Color2="9F78FF",Volume=0.55,Speed=1,HoverScale=1.025,PressScale=0.95,HoverLift=2,HoverRotation=0,Stagger=0.018,StaggerDirection="Forward",ReduceMotion=false,SmoothTransitions=true,ClickSound="",HoverSound="",PressSound="",ReleaseSound="",TabSound="",OpenSound="",CloseSound=""},Presets={},Tabs={}}
		CK.EnsureCustomTabs(PreviewTabKeys); CK.NormalizeCustom(); jsonBox.Text=CK.CustomCode(); fxJson.Text=HttpService:JSONEncode(CK.Custom.Effects); for k,b in pairs(fxBoxes) do b.Text=FxText(CK.Custom.Effects[k]) end; PaintAdvancedTabs(); Mark(); Say("custom menu reset")
	end)
	local customSaveHint = New("TextLabel", advancedBlock, {Size=UDim2.new(1,0,0,44), BackgroundTransparency=1, Text="VX5 supports stacked FX everywhere. Global defaults can be overridden per widget and per event. Sound ids, easing, colors, duration, speed, size, click actions and full menu JSON are shareable.", TextColor3=K_MUTE, Font=GOTHM, TextSize=9, TextWrapped=true, TextXAlignment=LEFT, LayoutOrder=23})
	for _, o in ipairs(CK.Schema) do
		if o.kind == "choice" then MakeChoice(o) elseif o.kind == "slider" then MakeSlider(o) else MakeText(o) end
	end

	-- ===== colors (right) =====
	local labels = {ToggleKnobOn = "TOGGLE · KNOB ON", ToggleKnobOff = "TOGGLE · KNOB OFF", SliderKnob = "SLIDER · KNOB", TabText = "TAB TEXT", TabTextActive = "ACTIVE TAB TEXT", TextRow = "TEXT ROWS", TextHeader = "TEXT HEADERS", TextValue = "VALUES", ButtonFill = "BUTTON FILL", ButtonText = "BUTTON TEXT", ToggleOn = "TOGGLE ON", SliderFill = "SLIDER FILL", TabActive = "TAB ACTIVE", Background = "BG", Secondary = "PANEL", Row = "ROW", Border = "BORDER", Text = "TEXT", SubText = "SUBTEXT", Muted = "MUTED", Accent = "ACCENT"}
	local descs = {ToggleKnobOn = "circle when on", ToggleKnobOff = "circle when off", SliderKnob = "circle on the bar", TabText = "tab labels", TabTextActive = "active tab label", TextRow = "labels", TextHeader = "section titles", TextValue = "slider values", ButtonFill = "button fill", ButtonText = "button text", ToggleOn = "on switch", SliderFill = "slider bar", TabActive = "active tab", Background = "window", Secondary = "bars", Row = "rows", Border = "lines", Text = "main", SubText = "dim", Muted = "hints", Accent = "accent"}
	New("TextLabel", colR, {Size = UDim2.new(1,0,0,14), BackgroundTransparency = 1, Text = "COLORS  (scroll the list, click what to paint)", TextColor3 = ACC, Font = GOTHB, TextSize = 11, TextXAlignment = LEFT, LayoutOrder = 1})
	local presetRow = Wrap(colR, 2)
	local chanList = Round(New("ScrollingFrame", colR, {Name = "chanlist", Size = UDim2.new(1,0,0,200), BackgroundColor3 = K_BG, BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = ACC,
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = 3}), 8)
	New("UIListLayout", chanList, {Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder})
	New("UIPadding", chanList, {PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,9)})

	local svBox = Round(New("ImageButton", colR, {Name = "svbox", Size = UDim2.new(1,0,0,130), BackgroundColor3 = Color3.fromRGB(255,0,0), AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = 4}), 8)
	local whiteOv = Round(New("Frame", svBox, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0}), 8)
	New("UIGradient", whiteOv, {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})})
	local blackOv = Round(New("Frame", svBox, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0}), 8)
	New("UIGradient", blackOv, {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})})
	local svCursor = Round(New("Frame", svBox, {AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.fromOffset(14,14), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 5}), 100)
	New("UIStroke", svCursor, {Color = Color3.new(1,1,1), Thickness = 2})

	local hueBar = Round(New("ImageButton", colR, {Name = "huebar", Size = UDim2.new(1,0,0,16), AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = 5}), 6)
	New("UIGradient", hueBar, {Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.000, Color3.fromHSV(0.000,1,1)), ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
		ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)), ColorSequenceKeypoint.new(0.500, Color3.fromHSV(0.500,1,1)),
		ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)), ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
		ColorSequenceKeypoint.new(1.000, Color3.fromHSV(1.000,1,1))})})
	local hueCursor = Round(New("Frame", hueBar, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0,0,0.5,0), Size = UDim2.fromOffset(6,22), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 5}), 3)
	New("UIStroke", hueCursor, {Color = Color3.new(0,0,0), Thickness = 1, Transparency = 0.4})

	local hexRow = New("Frame", colR, {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, LayoutOrder = 6})
	New("TextLabel", hexRow, {Size = UDim2.fromOffset(34,30), BackgroundTransparency = 1, Text = "HEX", TextColor3 = K_SUB, Font = GOTHB, TextSize = 12, TextXAlignment = LEFT})
	local hexBox = Round(New("TextBox", hexRow, {Name = "hexbox", Position = UDim2.fromOffset(40,0), Size = UDim2.new(1,-84,0,30), BackgroundColor3 = K_ROW, Text = "#FFFFFF", TextColor3 = K_TEXT,
		Font = CODE, TextSize = 13, ClearTextOnFocus = false, BorderSizePixel = 0}), 6)
	New("UIStroke", hexBox, {Color = K_LINE, Thickness = 1})
	New("UIPadding", hexBox, {PaddingLeft = UDim.new(0,10)})
	local hexSwatch = Round(New("Frame", hexRow, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,0), Size = UDim2.fromOffset(30,30), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0}), 6)
	New("UIStroke", hexSwatch, {Color = K_LINE, Thickness = 1})

	local glassLabel = New("TextLabel", colR, {Size = UDim2.new(1,0,0,14), BackgroundTransparency = 1, Text = "GLASS  0%", TextColor3 = K_SUB, Font = GOTHM, TextSize = 11, TextXAlignment = LEFT, LayoutOrder = 7})
	local glassHit = New("Frame", colR, {Name = "glasshit", Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, LayoutOrder = 8})
	local glassTrack = Round(New("Frame", glassHit, {AnchorPoint = Vector2.new(0,0.5), Position = UDim2.fromScale(0,0.5), Size = UDim2.new(1,0,0,8), BackgroundColor3 = K_ROW, BorderSizePixel = 0}), 4)
	local glassFill = Round(New("Frame", glassTrack, {Size = UDim2.fromScale(0,1), BackgroundColor3 = Color3.fromRGB(150,200,255), BorderSizePixel = 0}), 4)
	New("TextLabel", colR, {Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1, Text = "higher = more see-through panels, frosted-glass look across the whole hub",
		TextColor3 = K_MUTE, Font = GOTHM, TextSize = 10, TextXAlignment = LEFT, TextWrapped = true, LayoutOrder = 9})

	local hue, sat, val = 0, 1, 1
	local ExtraChanKeys = {"TextRow", "TextHeader", "TextValue", "ButtonFill", "ButtonText", "ToggleOn", "SliderFill", "TabActive", "TabText", "TabTextActive", "ToggleKnobOn", "ToggleKnobOff", "SliderKnob"}
	local ExtraSet = {}
	for _, k in ipairs(ExtraChanKeys) do ExtraSet[k] = true end
	local function ExtraStore(k) if k == "TextRow" or k == "TextHeader" or k == "TextValue" then return TextOverrides end return ElemOverrides end
	local function GetChan(k)
		if ExtraSet[k] then return ExtraStore(k)[k] or Theme[k] end
		return Themes.Custom[k]
	end
	local function SetChan(k, col)
		if ExtraSet[k] then ExtraStore(k)[k] = col; Theme[k] = col; SaveTextColors() else Themes.Custom[k] = col end
	end
	local activeKey = "Accent"
	local channelRows = {}
	local function CurrentColor() return Color3.fromHSV(hue, sat, val) end
	local function HexOf(col) return string.format("#%02X%02X%02X", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5)) end
	local function PaintSwatches()
		for key, e in pairs(channelRows) do
			e.sw.BackgroundColor3 = GetChan(key)
			e.stroke.Thickness = key == activeKey and 2 or 1
			e.stroke.Color = key == activeKey and ACC or K_LINE
			e.row.BackgroundColor3 = key == activeKey and Color3.fromRGB(38,36,52) or K_ROW
		end
	end
	local function LoadPickerFrom(col)
		hue, sat, val = Color3.toHSV(col)
		svBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		svCursor.Position = UDim2.fromScale(sat, 1 - val)
		hueCursor.Position = UDim2.fromScale(hue, 0.5)
		hexBox.Text = HexOf(col)
		hexSwatch.BackgroundColor3 = col
	end
	local function PushToKey()
		local col = CurrentColor()
		SetChan(activeKey, col)
		CK.SyncTheme()
		PaintSwatches()
		hexBox.Text = HexOf(col)
		hexSwatch.BackgroundColor3 = col
		Mark()
	end
	RefreshColors = function()
		PaintSwatches()
		LoadPickerFrom(GetChan(activeKey))
	end
	local AllChanKeys = {}
	for _, k in ipairs(ThemeKeys) do table.insert(AllChanKeys, k) end
	for _, k in ipairs(ExtraChanKeys) do table.insert(AllChanKeys, k) end
	for i, k in ipairs(AllChanKeys) do
		local row = Round(New("TextButton", chanList, {Name = "chan|" .. k, Size = UDim2.new(1,0,0,32), BackgroundColor3 = K_ROW, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i}), 7)
		local sw = Round(New("Frame", row, {Position = UDim2.fromOffset(6,6), Size = UDim2.fromOffset(20,20), BackgroundColor3 = GetChan(k), BorderSizePixel = 0}), 5)
		local stroke = New("UIStroke", sw, {Color = K_LINE, Thickness = 1})
		New("TextLabel", row, {Position = UDim2.fromOffset(36,0), Size = UDim2.new(0.5,-30,1,0), BackgroundTransparency = 1, Text = labels[k], TextColor3 = K_TEXT, Font = GOTHM, TextSize = 12, TextXAlignment = LEFT})
		New("TextLabel", row, {Position = UDim2.new(0.5,0,0,0), Size = UDim2.new(0.5,-10,1,0), BackgroundTransparency = 1, Text = descs[k], TextColor3 = K_MUTE, Font = GOTHM, TextSize = 10, TextXAlignment = RIGHT})
		channelRows[k] = {sw = sw, stroke = stroke, row = row}
		row.MouseButton1Click:Connect(function() activeKey = k; RefreshColors() end)
	end
	for _, pr in ipairs(BuilderPresets) do
		local sw = Round(New("TextButton", presetRow, {Name = "palette|" .. pr[1], Size = UDim2.fromOffset(26,26), BackgroundColor3 = Color3.fromRGB(table.unpack(pr[2])), Text = "", AutoButtonColor = false, BorderSizePixel = 0}), 6)
		New("UIStroke", sw, {Color = Color3.fromRGB(table.unpack(pr[9])), Thickness = 2})
		sw.MouseButton1Click:Connect(function()
			PushUndo(); ApplyPalette(pr[1]); CK.SyncTheme(); RefreshColors(); Mark()
		end)
	end
	local function SizeList()
		local avail = colR.AbsoluteSize.Y / math.max(scale.Scale, 0.01)
		chanList.Size = UDim2.new(1, 0, 0, math.clamp(avail - 390, 104, 296))
	end
	Keep(colR:GetPropertyChangedSignal("AbsoluteSize"):Connect(SizeList))

	local function fromSV(pos)
		sat = math.clamp((pos.X - svBox.AbsolutePosition.X) / math.max(svBox.AbsoluteSize.X, 1), 0, 1)
		val = 1 - math.clamp((pos.Y - svBox.AbsolutePosition.Y) / math.max(svBox.AbsoluteSize.Y, 1), 0, 1)
		svCursor.Position = UDim2.fromScale(sat, 1 - val)
		PushToKey()
	end
	local function fromHue(pos)
		hue = math.clamp((pos.X - hueBar.AbsolutePosition.X) / math.max(hueBar.AbsoluteSize.X, 1), 0, 1)
		hueCursor.Position = UDim2.fromScale(hue, 0.5)
		svBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		PushToKey()
	end
	svBox.InputBegan:Connect(function(input) BeginDrag(input, fromSV) end)
	hueBar.InputBegan:Connect(function(input) BeginDrag(input, fromHue) end)
	hexBox.FocusLost:Connect(function()
		local hx = string.match(hexBox.Text, "^#?(%x%x%x%x%x%x)$")
		if hx then
			PushUndo()
			local col = Color3.fromRGB(tonumber(string.sub(hx,1,2), 16), tonumber(string.sub(hx,3,4), 16), tonumber(string.sub(hx,5,6), 16))
			SetChan(activeKey, col)
			CK.SyncTheme()
			PaintSwatches()
			LoadPickerFrom(col)
			Mark()
		else
			hexBox.Text = HexOf(GetChan(activeKey))
		end
	end)
	PaintGlass = function()
		local a = Prefs.GlassAlpha
		glassFill.Size = UDim2.fromScale(a / 0.85, 1)
		glassLabel.Text = string.format("GLASS  %d%%", math.floor(a / 0.85 * 100 + 0.5))
	end
	local function fromGlass(pos)
		Prefs.GlassAlpha = math.clamp((pos.X - glassTrack.AbsolutePosition.X) / math.max(glassTrack.AbsoluteSize.X, 1), 0, 1) * 0.85
		PaintGlass(); Mark()
	end
	glassHit.InputBegan:Connect(function(input) BeginDrag(input, fromGlass) end)

	-- ===== footer =====
	local foot = New("Frame", card, {AnchorPoint = Vector2.new(0,1), Position = UDim2.new(0,0,1,0), Size = UDim2.new(1,0,0,56), BackgroundTransparency = 1})
	local function FootBtn(text, xp, w, fill)
		return Round(New("TextButton", foot, {Name = text, Position = UDim2.fromOffset(xp, 13), Size = UDim2.fromOffset(w, 30), BackgroundColor3 = fill or K_ROW, Text = text,
			TextColor3 = fill and K_BG or Color3.fromRGB(190,190,198), Font = GOTHB, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0}), 7)
	end
	local cancelBtn = FootBtn("CANCEL", 16, 84)
	local resetBtn = FootBtn("RESET", 108, 70)
	local randBtn = FootBtn("RANDOM", 186, 84)
	undoBtn = FootBtn("UNDO", 290, 64)
	redoBtn = FootBtn("REDO", 362, 64)
	local saveBtn = FootBtn("SAVE AND USE", 0, 170, ACC)
	saveBtn.AnchorPoint = Vector2.new(1,0)
	saveBtn.Position = UDim2.new(1,-16,0,13)
	PaintHistory()

	Keep(UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
			if input.KeyCode == Enum.KeyCode.Z then Undo() elseif input.KeyCode == Enum.KeyCode.Y then Redo() end
		end
	end))

	local function Restore()
		for k, v in pairs(snap.cfg) do CK.Cfg[k] = v end
		for k, v in pairs(snap.cols) do Themes.Custom[k] = v end
		CK.Custom = CloneTable(snap.custom or CK.Custom)
		CK.NormalizeCustom()
		Prefs.GlassAlpha = snap.glass
		Prefs.Theme, Prefs.Accent = snap.theme, snap.accent
		ApplyTheme()
	end
	local closed = false
	local function CloseWith(fn, keep)
		if closed then return end
		closed = true
		for _, cn in ipairs(conns) do cn:Disconnect() end
		table.clear(conns)
		for _, cn in ipairs(mockConns) do cn:Disconnect() end
		table.clear(mockConns)
		if mockB then mockB.Destroy(); mockB = nil end
		if not keep then Restore() end
		Tween(dim, {BackgroundTransparency = 1}, 0.25)
		Tween(card, {GroupTransparency = 1}, 0.25)
		task.delay(0.28, function() gui:Destroy(); fn() end)
	end
	cancelBtn.MouseButton1Click:Connect(function() CloseWith(onCancel, false) end)
	undoBtn.MouseButton1Click:Connect(Undo)
	redoBtn.MouseButton1Click:Connect(Redo)
	resetBtn.MouseButton1Click:Connect(function() ApplyKit(CK.Kits[1]); Say("reset to Classic") end)
	randBtn.MouseButton1Click:Connect(function()
		PushUndo()
		for _, o in ipairs(CK.Schema) do
			if o.kind == "choice" then
				CK.Cfg[o.key] = o.opts[math.random(#o.opts)]
			elseif o.kind == "slider" then
				CK.Cfg[o.key] = o.min + math.random(0, math.floor((o.max - o.min) / o.step + 0.0001)) * o.step
			end
		end
		ApplyPalette(BuilderPresets[math.random(#BuilderPresets)][1])
		CK.SyncTheme()
		RefreshOptions(); RefreshColors(); Mark()
		Say("random build, undo if you hate it")
	end)
	saveBtn.MouseButton1Click:Connect(function()
		SaveCustomTheme()
		CK.Save()
		CK.SaveCustom()
		DebugLog.Push("system", "custom menu saved by " .. LocalPlayer.Name .. ", layout = " .. tostring(CK.Cfg.Nav) .. ", glass = " .. tostring(Prefs.GlassAlpha))
		CloseWith(onDone, true)
	end)

	-- ===== responsive columns + first paint =====
	local function Layout()
		local w = card.AbsoluteSize.X / math.max(scale.Scale, 0.01)
		local lw = math.clamp(math.floor(w * 0.25), 220, 330)
		local rw = math.clamp(math.floor(w * 0.21), 200, 280)
		colL.Position = UDim2.fromOffset(16, 0)
		colL.Size = UDim2.new(0, lw, 1, 0)
		colR.AnchorPoint = Vector2.new(1, 0)
		colR.Position = UDim2.new(1, -16, 0, 0)
		colR.Size = UDim2.new(0, rw, 1, 0)
		colC.Position = UDim2.fromOffset(16 + lw + 10, 0)
		colC.Size = UDim2.new(1, -(16 + lw + 10 + rw + 10 + 16), 1, 0)
	end
	Keep(card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() Layout(); SizeList(); UpdateMockScale() end))
	Layout()
	Relayout()
	RefreshOptions()
	RefreshColors()
	PaintGlass()
	SizeList()
	BuildMock()

	Tween(dim, {BackgroundTransparency = 0.4}, 0.35)
	Tween(card, {GroupTransparency = 0}, 0.3)
	Tween(scale, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
end

local function RunMenuPicker(onPick)
	local gui = New("ScreenGui", PlayerGui, {Name = "VortexMenuPick", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 1090})
	local dim = New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true})
	Tween(dim, {BackgroundTransparency = 0.4}, 0.4)
	local holder = New("CanvasGroup", gui, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, GroupTransparency = 1})
	Tween(holder, {GroupTransparency = 0}, 0.4)

	New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0.1,0), Size = UDim2.fromOffset(600,30), BackgroundTransparency = 1,
		Text = "CHOOSE YOUR MENU", TextColor3 = Color3.fromRGB(235,235,240), Font = GOTHB, TextSize = 22})
	New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0.1,32), Size = UDim2.fromOffset(600,18), BackgroundTransparency = 1,
		Text = "same features, eight completely different interfaces", TextColor3 = Color3.fromRGB(150,150,164), Font = GOTHM, TextSize = 12})

	local closeAll = Round(New("TextButton", holder, {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-24,0,24), Size = UDim2.fromOffset(34,34), BackgroundColor3 = Color3.fromRGB(24,24,30),
		Text = "X", TextColor3 = Color3.fromRGB(255,90,100), Font = GOTHB, TextSize = 16, AutoButtonColor = false, BorderSizePixel = 0}), 8)

	local names = {"Sidebar", "Custom"}
	local descs = {Sidebar = "Sidebar tabs + rows", Floating = "Floating draggable panels", Taskbar = "Bottom dock + tile grid", Console = "Monospace console",
		Compact = "Top pill, tap-to-expand sheet", Overlay = "Always-on bottom HUD + pop panel", Wheel = "Ring of wedges + side panel", Custom = "Build your own menu, brick by brick"}
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
		if name == "Sidebar" then
			Box(parent, 0, 0, 44, 150, p.Secondary)
			for i = 1, 5 do Box(parent, 8, 12 + (i - 1) * 24, 28, 14, i == 1 and p.Row or p.Secondary, 4) end
			Box(parent, 0, 12, 3, 14, p.Accent)
			for i = 1, 4 do
				local r = Box(parent, 54, 10 + (i - 1) * 34, 126, 26, p.Row, 6)
				Box(r, 8, 9, 60, 8, p.SubText, 3)
				Box(r, 96, 7, 22, 12, i % 2 == 1 and p.Accent or p.Border, 6)
			end
		elseif name == "Floating" then
			for i, pos in ipairs({{8, 8}, {70, 30}, {28, 82}}) do
				local w = Box(parent, pos[1], pos[2], 100, 60, p.Background, 5)
				New("UIStroke", w, {Color = p.Border, Thickness = 1})
				Box(w, 0, 0, 100, 12, p.Secondary, 5); Box(w, 0, 11, 100, 2, p.Accent)
				Box(w, 8, 20, 60, 6, p.SubText, 2); Box(w, 8, 32, 44, 6, p.Row, 2); Box(w, 8, 44, 70, 6, p.Row, 2)
			end
		elseif name == "Taskbar" then
			local pn = Box(parent, 14, 6, 152, 92, p.Background, 10)
			New("UIStroke", pn, {Color = p.Border, Thickness = 1})
			for i = 0, 3 do
				local t = Box(pn, 8 + (i % 2) * 70, 10 + math.floor(i / 2) * 32, 64, 26, i == 0 and p.Accent or p.Row, 7)
				Box(t, 8, 9, 30, 8, i == 0 and p.Background or p.SubText, 3)
			end
			local dk = Box(parent, 30, 112, 120, 26, p.Secondary, 13)
			for i = 0, 3 do Box(dk, 10 + i * 27, 7, 22, 12, i == 0 and p.Accent or p.Row, 6) end
		elseif name == "Console" then
			local t = Box(parent, 6, 6, 168, 138, p.Background)
			New("UIStroke", t, {Color = p.Accent, Thickness = 1})
			Box(t, 0, 0, 168, 12, p.Secondary)
			Box(t, 6, 5, 50, 3, p.Accent)
			for i = 1, 7 do
				Box(t, 8, 20 + (i - 1) * 16, 40 + (i * 13) % 50, 5, p.SubText)
				Box(t, 130, 20 + (i - 1) * 16, 26, 5, i % 2 == 0 and p.Accent or p.Muted)
			end
		elseif name == "Compact" then
			local pill = Box(parent, 30, 4, 120, 20, p.Secondary, 10)
			New("UIStroke", pill, {Color = p.Accent, Thickness = 1})
			for i = 0, 3 do Box(pill, 8 + i * 24, 4, 18, 12, i == 0 and p.Accent or p.Row, 6) end
			local sheet = Box(parent, 20, 30, 140, 100, p.Background, 10)
			New("UIStroke", sheet, {Color = p.Border, Thickness = 1})
			for i = 1, 4 do Box(sheet, 10, 8 + (i - 1) * 22, 120, 16, p.Row, 5) end
		elseif name == "Overlay" then
			local strip = Box(parent, 10, 118, 160, 24, p.Background, 12)
			New("UIStroke", strip, {Color = p.Accent, Thickness = 1})
			for i = 0, 3 do Box(strip, 8 + i * 38, 6, 32, 12, p.Row, 4) end
			local panel = Box(parent, 30, 20, 120, 90, p.Secondary, 8)
			New("UIStroke", panel, {Color = p.Border, Thickness = 1})
			for i = 1, 3 do Box(panel, 8, 8 + (i - 1) * 26, 104, 18, p.Row, 5) end
		elseif name == "Wheel" then
			local ring = Box(parent, 20, 15, 120, 120, p.Secondary, 60)
			New("UIStroke", ring, {Color = p.Accent, Thickness = 1.5})
			Box(ring, 44, 44, 32, 32, p.Background, 16)
			for i = 0, 5 do
				local a = math.rad(-90 + i * 60)
				Box(ring, 60 + math.cos(a) * 46 - 8, 60 + math.sin(a) * 46 - 8, 16, 16, i == 0 and p.Accent or p.Row, 8)
			end
			Box(parent, 148, 20, 32, 110, p.Background, 6)
		elseif name == "Custom" then
			local swatchColors = {Color3.fromRGB(255,96,150), Color3.fromRGB(70,210,255), Color3.fromRGB(70,225,140), Color3.fromRGB(255,190,70)}
			for i, c in ipairs(swatchColors) do
				Box(parent, 14 + ((i-1) % 2) * 84, 14 + math.floor((i-1) / 2) * 60, 70, 48, c, 8)
			end
			local plus = Box(parent, 70, 120, 30, 30, p.Row, 15)
			New("UIStroke", plus, {Color = p.Accent, Thickness = 1.5})
			New("TextLabel", plus, {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "+", TextColor3 = p.Accent, Font = GOTHB, TextSize = 20})
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
			if name == "Custom" then
				RunSkinBuilder(function()
					if picked then return end
					picked = true
					DebugLog.Push("system", "menu selected: Custom (built)")
					Tween(dim, {BackgroundTransparency = 1}, 0.25)
					Tween(holder, {GroupTransparency = 1}, 0.25)
					task.delay(0.28, function()
						gui:Destroy()
						onPick("Custom")
					end)
				end, function() end)
				return
			end
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


local function RunLoadingScreen(onDone)
	local gui = New("ScreenGui", PlayerGui, {Name = "VortexLoading", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 1080})
	local dim = New("Frame", gui, {Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.fromRGB(6,6,8), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true})
	Tween(dim, {BackgroundTransparency = 0}, 0.3)

	local holder = New("Frame", gui, {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(360,120), BackgroundTransparency = 1})

	local title = New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,0), Size = UDim2.fromOffset(360,28), BackgroundTransparency = 1,
		Text = "VORTEX", TextColor3 = Color3.fromRGB(240,240,244), Font = GOTHB, TextSize = 24, TextTransparency = 1})

	local status = New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,34), Size = UDim2.fromOffset(360,16), BackgroundTransparency = 1,
		Text = "initializing", TextColor3 = Color3.fromRGB(140,140,150), Font = GOTHM, TextSize = 12, TextTransparency = 1})

	local barBg = Round(New("Frame", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,64), Size = UDim2.fromOffset(300,4), BackgroundColor3 = Color3.fromRGB(26,26,30), BorderSizePixel = 0, BackgroundTransparency = 1}), 2)
	local barFill = Round(New("Frame", barBg, {Size = UDim2.fromScale(0,1), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0}), 2)

	local pct = New("TextLabel", holder, {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,78), Size = UDim2.fromOffset(300,16), BackgroundTransparency = 1,
		Text = "0%", TextColor3 = Color3.fromRGB(90,90,100), Font = GOTHM, TextSize = 11, TextTransparency = 1})

	Tween(title, {TextTransparency = 0}, 0.3)
	Tween(status, {TextTransparency = 0}, 0.3)
	Tween(barBg, {BackgroundTransparency = 0}, 0.3)
	Tween(pct, {TextTransparency = 0}, 0.3)

	local stages = {
		{0.22, "resolving modules"},
		{0.47, "fetching environment"},
		{0.68, "binding services"},
		{0.86, "building interface"},
		{1.00, "ready"},
	}

	-- The bar itself is animated by TweenService, so its motion stays smooth even
	-- when the scheduler is busy. The percentage label only reads the tweened size.
	task.spawn(function()
		local pctConn
		local lastPct = -1
		pctConn = RunService.RenderStepped:Connect(function()
			if not gui.Parent then
				if pctConn then pctConn:Disconnect() end
				return
			end
			local value = math.clamp(barFill.Size.X.Scale, 0, 1)
			local whole = math.floor(value * 100 + 0.5)
			if whole ~= lastPct then
				lastPct = whole
				pct.Text = string.format("%d%%", whole)
			end
		end)

		for _, stage in ipairs(stages) do
			local target, label = stage[1], stage[2]
			local current = math.clamp(barFill.Size.X.Scale, 0, 1)
			local distance = math.max(target - current, 0)
			status.Text = label

			local duration = math.max(0.35, distance * 3.2)
			local tween = TweenService:Create(
				barFill,
				TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
				{Size = UDim2.fromScale(target, 1)}
			)
			tween:Play()
			tween.Completed:Wait()
			task.wait(0.06)
		end

		if pctConn then pctConn:Disconnect() end
		pct.Text = "100%"
		task.wait(0.18)

		Tween(dim, {BackgroundTransparency = 1}, 0.3)
		Tween(title, {TextTransparency = 1}, 0.25)
		Tween(status, {TextTransparency = 1}, 0.25)
		Tween(barBg, {BackgroundTransparency = 1}, 0.25)
		Tween(pct, {TextTransparency = 1}, 0.25)
		task.wait(0.32)

		if gui.Parent then gui:Destroy() end
		onDone()
	end)
end

local function RunEula(onAccept)
	local gui = New("ScreenGui", PlayerGui, {Name = "VortexEula", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 1085})
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
		"This software is provided free of charge, as is, with no warranty of any kind, express or implied, including fitness for a particular purpose or non-infringement.",
		"Redistribution, resale, or re-hosting under a different name, in whole or in part, modified or unmodified, is prohibited without explicit written permission.",
		"You are solely responsible for how and where you use this software, including any consequences within a game, platform, or service (bans, restrictions, account action).",
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

RunLoadingScreen(function()
	if LoadSetting("eula_accepted", "0") == "1" then
		DebugLog.Push("system", "eula previously accepted, skipping")
		ProceedPastEula()
	else
		DebugLog.Push("system", "eula presented")
		RunEula(function()
			SaveSetting("eula_accepted", "1")
			ProceedPastEula()
		end)
	end
end)

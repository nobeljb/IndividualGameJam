extends Control

const WIN_BACKGROUND := preload("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_land.png")
const LOSE_BACKGROUND := preload("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_shroom.png")
const WIN_ART := preload("res://assets/kenney_platformerpack/PNG/Tiles/doorOpen_mid.png")
const LOSE_ART := preload("res://assets/kenney_platformerpack/PNG/Tiles/doorClosed_mid.png")

@onready var backdrop: TextureRect = $Backdrop as TextureRect
@onready var backdrop_tint: ColorRect = $BackdropTint as ColorRect
@onready var card: PanelContainer = $MarginContainer/CenterContainer/Card as PanelContainer
@onready var badge_label: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/HeroRow/TextColumn/BadgeLabel as Label
@onready var title_label: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/HeroRow/TextColumn/TitleLabel as Label
@onready var body_label: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/HeroRow/TextColumn/BodyLabel as Label
@onready var hero_art: TextureRect = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/HeroRow/ArtFrame/ArtInset/HeroArt as TextureRect
@onready var stars_value: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/StatsStrip/MarginContainer/StatsRow/StarsStat/Text/Value as Label
@onready var lives_value: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/StatsStrip/MarginContainer/StatsRow/LivesStat/Text/Value as Label
@onready var camp_value: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/StatsStrip/MarginContainer/StatsRow/CampStat/Text/Value as Label
@onready var recap_label: Label = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/RecapLabel as Label
@onready var retry_button: Button = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/ButtonRow/RetryButton as Button
@onready var menu_button: Button = $MarginContainer/CenterContainer/Card/MarginContainer/VBoxContainer/ButtonRow/MenuButton as Button


func _ready() -> void:
	var game_flow: GameFlowState = get_node("/root/GameFlow") as GameFlowState
	_apply_result(game_flow)
	_play_intro()
	retry_button.pressed.connect(_on_retry_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)
	retry_button.grab_focus()


func _apply_result(game_flow: GameFlowState) -> void:
	if game_flow == null:
		return

	var accent_color: Color = Color(0.835294, 0.764706, 0.560784, 1.0)
	if game_flow.did_win:
		backdrop.texture = WIN_BACKGROUND
		backdrop_tint.color = Color(0.058824, 0.133333, 0.117647, 0.62)
		hero_art.texture = WIN_ART
		badge_label.text = "Perjalanan Selesai"
		recap_label.text = "Fragmen bintang terkumpul, safe spot terbangun, dan gerbang akhir berhasil kamu lewati."
		accent_color = Color(0.921569, 0.85098, 0.6, 1.0)
	else:
		backdrop.texture = LOSE_BACKGROUND
		backdrop_tint.color = Color(0.117647, 0.0627451, 0.101961, 0.72)
		hero_art.texture = LOSE_ART
		badge_label.text = "Singgah Dulu"
		recap_label.text = "Ritmenya sudah terbentuk. Coba lagi, bangun momentum, lalu buka gerbang itu saat semuanya sudah siap."
		accent_color = Color(0.964706, 0.623529, 0.611765, 1.0)

	title_label.text = game_flow.summary_title
	body_label.text = game_flow.summary_body
	stars_value.text = str(game_flow.stars_collected)
	lives_value.text = str(game_flow.lives_left)
	camp_value.text = "Aktif" if game_flow.safe_spot_built else "Belum"

	badge_label.add_theme_color_override("font_color", accent_color)
	title_label.add_theme_color_override("font_color", Color(0.972549, 0.964706, 0.921569, 1.0))
	body_label.add_theme_color_override("font_color", Color(0.854902, 0.878431, 0.862745, 1.0))
	recap_label.add_theme_color_override("font_color", accent_color)


func _play_intro() -> void:
	card.modulate = Color(1.0, 1.0, 1.0, 0.0)
	card.scale = Vector2(0.97, 0.97)
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.35)
	tween.parallel().tween_property(card, "scale", Vector2.ONE, 0.42)


func _on_retry_button_pressed() -> void:
	var game_flow: GameFlowState = get_node("/root/GameFlow") as GameFlowState
	if game_flow != null:
		game_flow.restart_level()


func _on_menu_button_pressed() -> void:
	var game_flow: GameFlowState = get_node("/root/GameFlow") as GameFlowState
	if game_flow != null:
		game_flow.open_main_menu()

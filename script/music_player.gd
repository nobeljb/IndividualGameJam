class_name MusicPlayer
extends AudioStreamPlayer

const DEFAULT_THEME := preload("res://sound/BGM.wav")
const VICTORY_THEME := preload("res://sound/401828__frankum__love-technohouse-peace.mp3")

enum ThemeState {
	NONE,
	DEFAULT,
	VICTORY,
}

var _current_theme: int = ThemeState.NONE


func _ready() -> void:
	play_default_theme()


func play_default_theme(force_restart: bool = false) -> void:
	if _current_theme == ThemeState.DEFAULT and playing and not force_restart:
		return

	_current_theme = ThemeState.DEFAULT
	_play_theme(DEFAULT_THEME, force_restart)


func play_victory_theme(force_restart: bool = true) -> void:
	if _current_theme == ThemeState.VICTORY and playing and not force_restart:
		return

	_current_theme = ThemeState.VICTORY
	_play_theme(VICTORY_THEME, force_restart)


func _play_theme(theme_stream: AudioStream, force_restart: bool) -> void:
	_set_loop_enabled(theme_stream, true)

	var stream_changed: bool = stream != theme_stream
	stream = theme_stream

	if force_restart or stream_changed or not playing:
		play()


func _set_loop_enabled(theme_stream: AudioStream, enabled: bool) -> void:
	if theme_stream is AudioStreamWAV:
		var wav_stream: AudioStreamWAV = theme_stream as AudioStreamWAV
		wav_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if enabled else AudioStreamWAV.LOOP_DISABLED
	elif theme_stream is AudioStreamMP3:
		var mp3_stream: AudioStreamMP3 = theme_stream as AudioStreamMP3
		mp3_stream.loop = enabled
	elif theme_stream is AudioStreamOggVorbis:
		var ogg_stream: AudioStreamOggVorbis = theme_stream as AudioStreamOggVorbis
		ogg_stream.loop = enabled

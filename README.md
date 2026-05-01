# Beyond Nginep's End

`Beyond Nginep's End` adalah game platformer 2D bertema fantasy chill. Pemain menjelajah satu level dari awal sampai akhir, mengumpulkan fragmen bintang, membangun safe spot di tengah perjalanan, menahan sakelar untuk membuka gerbang, lalu mencapai pintu akhir.

Project ini dibuat untuk memenuhi requirement Solo Game Project sekaligus 3 diversifier:
- `D17` Plesetan Judul Anime: `Beyond Nginep's End` dari `Beyond Journey's End`
- `D21` Nginep Santai: pemain bisa craft safe spot di tengah level
- `D121` Rigidbody: safe spot memunculkan `RestCharm` bertipe `RigidBody2D`

## Fitur Utama

- Menu awal dengan tombol `Mulai Perjalanan` dan `Keluar`
- HUD yang menampilkan fragmen, nyawa, status safe spot, prompt, dan objective
- Safe spot craftable di area camp setelah pemain mengumpulkan 3 fragmen
- Pressure switch yang aktif hanya saat diinjak player atau ditahan crate
- Gerbang akhir yang hanya terbuka selama switch masih ditekan
- End screen terpisah untuk kondisi menang dan kalah

## Kontrol

- `Left / Right`: bergerak
- `Up`: lompat
- `Up` di udara: double jump
- `Down`: crouch
- `Double tap Left / Right`: dash
- `C`: craft safe spot saat berada di area camp dan fragmen sudah cukup

## Alur Permainan

1. Mulai dari `MainMenu`.
2. Kumpulkan minimal 3 fragmen bintang.
3. Pergi ke area camp di tengah level lalu tekan `C` untuk membangun safe spot.
4. Lanjutkan ke area puzzle dan tahan floor switch dengan crate atau pijakan player.
5. Saat switch tertahan, gerbang akhir terbuka.
6. Masuk ke pintu akhir untuk menang.

Jika nyawa habis, permainan masuk ke end screen kalah. Jika safe spot sudah aktif, percobaan berikutnya bisa diarahkan dari checkpoint yang sudah dibangun.

## End Condition

- `Win`: pemain mencapai pintu akhir saat gerbang terbuka
- `Lose`: nyawa pemain habis

Kedua hasil tersebut sekarang memakai scene ending terpisah dengan tombol `Coba Lagi` dan `Menu Utama`.

## Diversifier Checklist

### D17 - Plesetan Judul Anime: Beyond Journey's End

- Judul game: `Beyond Nginep's End`, plesetan dari `Beyond Journey's End`
- Tema: fantasy chill, perjalanan santai, campsite, fragmen bintang, dan gerbang akhir
- Bukti utama: `project.godot`, `scenes/MainMenu.tscn`, `scenes/hud.tscn`

### D21 - Nginep Santai

- Pemain mengumpulkan 3 fragmen bintang
- Di area `CampArea`, pemain bisa menekan `C` untuk craft safe spot
- Safe spot menjadi checkpoint respawn saat pemain gugur
- Bukti utama: `script/camp_area.gd`, `script/game_manager.gd`, `scenes/camp_area.tscn`, `scenes/safe_spot.tscn`

### D121 - Rigidbody

- Safe spot memunculkan `RestCharm` bertipe `RigidBody2D`
- `RestCharm` menerima impulse saat spawn dan jatuh dengan physics
- Bukti utama: `script/safe_spot.gd`, `scenes/safe_spot.tscn`

## Kesesuaian Requirement

- Minimal 1 GDScript: gameplay dikelola oleh beberapa script di folder `script/`
- UI state permainan: HUD menampilkan fragmen, nyawa, safe spot, prompt, dan objective
- Menu awal permainan: tersedia di `scenes/MainMenu.tscn`
- End condition: win dan lose sudah diimplementasikan
- Minimal 1 level playable: `scenes/Main.tscn`
- Minimal 1 challenge: craft safe spot dan tahan floor switch untuk membuka gerbang
- Minimal 1 objek yang dikendalikan pemain: `Player` di `scenes/player.tscn`

## Struktur Penting

- `scenes/Main.tscn`: level utama
- `scenes/MainMenu.tscn`: menu awal
- `scenes/EndScreen.tscn`: end screen menang/kalah
- `script/game_manager.gd`: state permainan, objective, respawn, dan flow ending
- `script/floor_switch.gd`: pressure switch on/off
- `script/game_flow.gd`: state antar-scene untuk end screen
- `script/player.gd`: movement player


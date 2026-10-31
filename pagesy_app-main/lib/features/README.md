# features/

Satu folder per fitur. Tiap fitur berdiri sendiri.

## Struktur per fitur
```
<fitur>/
├── data/            # model + repository (panggil API Laravel)
└── presentation/    # pages, widgets, state
```

## Aturan
- Fitur baru = folder baru, salin struktur di atas.
- Jangan import `data/` atau `presentation/` fitur lain. Kalau perlu dipakai bersama, pindahkan ke `core/`.
- Jika logika satu fitur menjadi rumit (hitungan, gabungan beberapa endpoint, offline), tambahkan `domain/` (entities, usecases) **khusus fitur itu**. Tidak perlu seragam.

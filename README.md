# nixos-config

Mój osobisty config NixOS, modularny, oparty o [flake-parts](https://flake.parts/) + [home-manager](https://github.com/nix-community/home-manager) + [plasma-manager](https://github.com/nix-community/plasma-manager) + [disko](https://github.com/nix-community/disko).

---

## Struktura katalogów

```
.
├── flake.nix               # wejście - inputs, outputs przez flake-parts + import-tree
├── flake.lock
├── guides/                 # notatki dla przyszłego-mnie (install, post-install)
└── modules/
    ├── meta.nix            # wspólne opcje: my.username, my.stateVersion itd.
    ├── hardware/           # moduły sprzętowe (GPU, bluetooth, drukarki...)
    │   └── nvidia.nix
    ├── nixos/              # moduły systemowe (services.*, programs.* na poziomie systemu)
    │   ├── base.nix
    │   ├── boot.nix
    │   ├── networking.nix
    │   ├── users.nix
    │   ├── audio.nix
    │   ├── plasma.nix       # Plasma jako DE (SDDM + plasma6)
    │   ├── ram-settings.nix
    │   └── packages-common.nix  # bazowe CLI bez configu
    ├── home/               # moduły home-manager (programs.*, user-scoped)
    │   └── plasma.nix       # plasma-manager: deklaratywny config plasmy usera
    ├── home-manager.nix    # podpięcie HM jako NixOS module + globalne imports
    └── hosts/
        ├── _common.nix      # lista modułów wspólna dla wszystkich hostów
        ├── pc/
        │   ├── default.nix
        │   ├── _hardware.nix
        │   └── _disko.nix
        └── laptop/
            └── default.nix
```

---

## Konwencje

### Prefix `_` = "specjalne, nie w rejestrze"

Pliki zaczynające się od `_` **nie są** modułami flake-parts i **nie pojawiają się** jako `self.nixosModules.*` / `self.homeModules.*`. Są to:

- **Host-specific pliki** (`_hardware.nix`, `_disko.nix`) - importowane bezpośrednio przez `default.nix` hosta
- **Aggregatory** (`_common.nix`) - zwracają listę modułów do użycia w `modules = [...]`

Pliki **bez** underscore to moduły flake-parts, automatycznie rejestrowane przez `import-tree` i dostępne jako `self.nixosModules.<nazwa>` / `self.homeModules.<nazwa>`.

### Dwa poziomy funkcji w modułach flake-parts

```nix
{ self, inputs, ... }: {                 # warstwa flake-parts (rejestracja)
  flake.nixosModules.boot = { ... }: {   # warstwa NixOS (właściwy config)
    boot.loader.systemd-boot.enable = true;
  };
}
```

- **Zewnętrzna funkcja** - args od flake-parts (`self`, `inputs`, `config` flake-parts)
- **Wewnętrzna funkcja** - args od NixOS-a (`pkgs`, `config` systemu, `lib`)

To są dwie różne przestrzenie - `inputs` dostępny w zewnętrznej, ale w wewnętrznej już nie (chyba że przez closure).

---

## Decision tree: gdzie dodać nową rzecz?

### Paczka bez configu (chcę tylko mieć binarkę)

**Pytanie:** czy to user-specific czy system-wide?

| Przypadek | Gdzie |
|---|---|
| GUI apka dla mnie (firefox, discord, telegram) | `modules/home/packages.nix`¹ → `home.packages` |
| CLI dla mojego usera (opencode, yt-dlp) | `modules/home/packages.nix`¹ → `home.packages` |
| Narzędzie systemowe (fsck, nmap, tcpdump) | `modules/nixos/packages-common.nix` → `environment.systemPackages` |
| Dostępne przed zalogowaniem / dla root | `modules/nixos/packages-common.nix` |

> ¹ **`modules/home/packages.nix` to plik do stworzenia** - jeszcze go nie ma w repo. Szablon:
> ```nix
> { ... }: {
>   flake.homeModules.packages = { pkgs, ... }: {
>     home.packages = with pkgs; [
>       firefox
>       telegram-desktop
>       discord
>       # itd.
>     ];
>   };
> }
> ```
> Po stworzeniu dodaj `self.homeModules.packages` do globalnych imports w `modules/home-manager.nix`.

### Paczka z configiem (chcę deklaratywnie zarządzać ustawieniami)

**Użyj dedykowanego modułu `programs.X` / `services.X`** zamiast ręcznie dorzucać paczkę + dotfile'y.

| Przypadek | Gdzie | Jak |
|---|---|---|
| User tool z configiem (git, neovim, tmux, zsh) | `modules/home/<nazwa>.nix` | `flake.homeModules.<nazwa>` z `programs.X` |
| Systemowa usługa (nginx, postgres, docker) | `modules/nixos/<nazwa>.nix` | `flake.nixosModules.<nazwa>` z `services.X` / `programs.X` |

> **Ważne:** `programs.git.enable = true` w HM **instaluje git + generuje config**. Nie musisz dodawać `git` do `home.packages` ani do `packages-common.nix`. Dublowanie = problemy.

### Moduł specyficzny dla sprzętu

→ `modules/hardware/<nazwa>.nix` (np. `nvidia.nix`, `bluetooth.nix`, `printer-brother.nix`)

### Coś co ma się aktywować tylko na jednej maszynie

→ `modules/hosts/<host>/default.nix`, w sekcji "moduły tylko dla tego hosta" albo inline overrides.

---

## Globalne vs host-specific w home-manager

### Globalne (każdy host dostaje) → `modules/home-manager.nix`

```nix
users.${config.my.username} = {
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager  # dependency
    self.homeModules.git                               # mój globalny moduł
    self.homeModules.neovim                            # mój globalny moduł
  ];
  ...
};
```

### Host-specific → `modules/hosts/<host>/default.nix`

```nix
({ config, ... }: {
  home-manager.users.${config.my.username}.imports = [
    self.homeModules.plasma   # tylko PC ma KDE
  ];
})
```

**Reguła:** "czy chcę to na każdej maszynie?" → tak: globalne, nie: host-specific. **Nie dubluj** tego samego modułu w obu miejscach.

---

## System vs home-manager - dwa różne `enable`

Przykład z plasmą który często myli:

```nix
# modules/nixos/plasma.nix
services.desktopManager.plasma6.enable = true;  # "zainstaluj KDE jako DE na systemie"

# modules/home/plasma.nix
programs.plasma.enable = true;                   # "zarządzaj moimi ustawieniami plasmy przez plasma-manager"
```

To **nie jest** duplikacja. Pierwsze = fizyczna obecność Plasmy (pakiety, sesja SDDM, dbus). Drugie = plasma-manager deklaratywnie zapisuje moje `programs.plasma.*` do `~/.config/`.

Analogicznie dla innych programów: NixOS-owy `programs.X.enable` i HM-owy `programs.X.enable` to zazwyczaj **różne rzeczy** - jedno systemowe, drugie user-scoped.

---

## Jak dodać nowy moduł - cheatsheet

### Nowy globalny HM moduł (np. git)

1. Stwórz `modules/home/git.nix`:
   ```nix
   { ... }: {
     flake.homeModules.git = { ... }: {
       programs.git = {
         enable = true;
         userName = "...";
         userEmail = "...";
       };
     };
   }
   ```
2. Dodaj do `imports` w `modules/home-manager.nix`:
   ```nix
   imports = [
     inputs.plasma-manager.homeModules.plasma-manager
     self.homeModules.git   # ← nowe
   ];
   ```
3. `sudo nixos-rebuild switch --flake .#<host>` (np. `.#pc`)

### Nowy systemowy moduł (np. docker)

1. Stwórz `modules/nixos/docker.nix`:
   ```nix
   { ... }: {
     flake.nixosModules.docker = { ... }: {
       virtualisation.docker.enable = true;
     };
   }
   ```
2. Jeśli chcę go na każdej maszynie → dodaj do `modules/hosts/_common.nix`
3. Jeśli tylko na wybranej → dodaj do `modules/hosts/<host>/default.nix` w sekcji moduły specyficzne

### Nowy host

1. Stwórz `modules/hosts/<nazwa>/default.nix` (wzorując się na `pc/`)
2. Skopiuj strukturę - `commonModules` z `_common.nix` + host-specific moduły + inline overrides
3. Opcjonalnie dodaj `_hardware.nix` / `_disko.nix` dla tego hosta

---

## Typowe pułapki

### Nie dublowanie paczek
Jeśli używam `programs.git.enable = true`, **nie dodaję** `git` dodatkowo do `home.packages` ani `environment.systemPackages`. Moduł `programs.X` już to robi.

### Użycie `config.my.username` zamiast hardkodu
```nix
# źle:
home-manager.users.mrcapi.imports = [...];

# dobrze:
home-manager.users.${config.my.username}.imports = [...];
```
Jedno źródło prawdy w `meta.nix`. Zmiana username w jednym miejscu.

### Pomylenie warstw argumentów
W module flake-parts `self`, `inputs` są w **zewnętrznej** funkcji. W **wewnętrznej** (właściwym NixOS module) są `pkgs`, `config` (systemu), `lib`. Jak potrzebuję `inputs` w wewnętrznej - capture'uję przez closure z zewnętrznej funkcji.

```nix
# ŹLE - "inputs" nie jest argumentem wewnętrznej funkcji, crash przy evalu
{ ... }: {
  flake.nixosModules.foo = { pkgs, inputs, ... }: {
    #                              ^^^^^^ nie istnieje tutaj
    environment.systemPackages = [ inputs.some-flake.packages.${pkgs.system}.default ];
  };
}

# DOBRZE - "inputs" pobrany w zewnętrznej funkcji, wewnętrzna używa przez closure
{ inputs, ... }: {
# ^^^^^^ tutaj dostajemy inputs od flake-parts
  flake.nixosModules.foo = { pkgs, ... }: {
    environment.systemPackages = [ inputs.some-flake.packages.${pkgs.system}.default ];
    #                              ^^^^^^ działa, bo zmienna jest "widoczna" z zewnętrznej funkcji
  };
}
```

Ta sama zasada działa dla `self` - dostajesz go w zewnętrznej funkcji (`{ self, ... }:`) i używasz w wewnętrznej przez closure. W hostach jest inaczej, bo tam jawnie przekazujesz `self`/`inputs` przez `specialArgs = { inherit self inputs; }` - wtedy są dostępne w każdym module.

### "Moduły na zapas"
Nie rozbijam paczek bez configu na osobne pliki (`modules/home/htop.nix` z 3 linijkami). Worek `packages.nix` wystarczy dopóki paczka nie zacznie mieć realnego configu - wtedy "awansuje" do dedykowanego pliku.

### Martwe komentarze
Jeśli zmieniam podejście w configu - **aktualizuję też ten README** i komentarze w plikach. Martwe komentarze są gorsze niż brak komentarzy, bo aktywnie wprowadzają w błąd.

---

## Użyteczne komendy

```bash
# Rebuild wybranego hosta (po # podajesz nazwę z flake.nixosConfigurations.*)
sudo nixos-rebuild switch --flake .#pc
sudo nixos-rebuild switch --flake .#laptop

# Test bez aktywacji (build + aktywacja bez wpisu w bootloaderze)
sudo nixos-rebuild test --flake .#pc

# Sprawdź co się zmieni (tylko build, bez aktywacji)
sudo nixos-rebuild dry-activate --flake .#pc

# Shortcut: bez #host bierze hostname z aktualnej maszyny
sudo nixos-rebuild switch --flake .

# Aktualizacja inputs
nix flake update

# Aktualizacja pojedynczego inputa
nix flake lock --update-input nixpkgs

# Sprawdzenie flake'a (eval, check)
nix flake check
```

---

## TODO / rzeczy do przemyślenia

- [ ] Sekrety (sops-nix albo agenix) - na razie brak, czas pomyśleć zanim pchnę coś wrażliwego
- [ ] Rozdzielenie profilu Git (prywatny vs pracowniczy) przez `programs.git.includes`
- [ ] Ewentualne wprowadzenie `wrapper-modules` - dopiero jak realnie będzie potrzebna portability

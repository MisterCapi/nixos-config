# Lista modułów wspólnych dla KAŻDEGO hosta.
{ self }: [
  self.nixosModules.base
  self.nixosModules.boot
  self.nixosModules.networking
  self.nixosModules.users
  self.nixosModules.audio
  self.nixosModules.ram-settings
  self.nixosModules.packages-common
  self.nixosModules.home-manager
  self.nixosModules.niri
]

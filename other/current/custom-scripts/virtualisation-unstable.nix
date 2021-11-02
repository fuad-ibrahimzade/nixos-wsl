let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixpkgs> { config = baseconfig; };
in
{

  disabledModules = [ 
    "virtualisation/virtualbox-host.nix" 
  ];
  imports = [ 
    <nixpkgs/nixos/modules/virtualisation/virtualbox-host.nix> 
  ];



  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      virtualbox = unstable.virtualbox;
    }; 

    virtualisation.libvirtd.enable = true;
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;


  };

    users.extraGroups.vboxusers.members = [ "qaqulya" ];
   
    programs.dconf.enable = true;
    environment.systemPackages = with unstable; [ virt-manager virtualbox ]; 
    users.users.qaqulya.extraGroups = [ "libvirtd" ];
 


}


hook.Add( "SpawnMenuOpen", "FlagCheckPET", function()
   if not LocalPlayer():getChar():hasFlags("pet") then
       return false
   end
end )
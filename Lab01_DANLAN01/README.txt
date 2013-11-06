RubyCamping
Program för administration av Ruby Camping
Version 1
Av: Daniel Lännström

Användning:
Starta programmet i konsolen med ruby RubyCamping.rb
Välj menyalternativ i huvudmenyn och följ de interaktiva 
instruktionerna.

Diskussion: 
Man skulle möjligen kunna göra flera objekt och klasser men jag antar
att det kommer i de senare labbarna. Annars är jag ganska övertygad om
att jag valt det enklaste sättet att göra detta program. Det viktiga är 
att man ser till att all data man läser in från användaren är gilltig så
det inte uppkommer korrupt data i systemet på grund av ignorans eller 
skadeglädje.

Klasser:
  Guest - Representerar en gäst 
    @names - Läsvänliga namn för de olika datafälten
    @data  - Vektor med attributerna för varje gäst
    
    print - Skriver ut uppgifterna som sparats i instansen

Funktioner:
  main_menu - Skriver ut huvudmenyn och läser in användarens val
  print_error_and_wait - Visar ett felmeddelande och väntar på att 
                         användaren ska bekräfta att hon läst det
  checking_in - Sköter incheckningen av en gäst 
  checing_out - Skriver bara ut gästens information och avslutar programmet
  read_multi_string - Läser in flera rader tills användaren skriver '.' på
                      en egen rad
  read_string - Läser in en sträng/rad  
  read_phone - Läser in ett telefonnummer som måste ha riktnummer
  read_date - Läser in ett datum
  

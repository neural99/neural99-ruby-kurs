RubyCamping
Program för administration av Ruby Camping
Version 2
Av: Daniel Lännström

Användning:
Starta programmet i konsolen med ruby main.rb
Välj menyalternativ i huvudmenyn och följ de interaktiva instruktionerna.

Systembeskrivning:
RubyCamping är huvudklassen som anropas från main.rb. Klassen har huvudsakligen bara en metod,
main_loop, som körs tills programmet avslutas.

RubyCamping knyter ihop alla delar och anvsvarar för att hålla reda på samligen av tomtplatser
och samtliga gäster. När en instans skapas görs 32 st. objekt av typen Plot som representerar
en tomt med tillhörande mätarvärde som en instans av klassen Electricity. Plot-objektet har
även en referens till den ev. gästen som bor på platsen. Guest-objektet behöver inte känna till
Plot-objektet eller Electricity-objektet så de är svagt kopplade.

RubyCamping behöver instansvariabler för att kunna spara ner MenuAlternative-objekten tills
main_loop anropas.

Guest-klassen håller reda på uppgifterna om en gäst. Den hanterar in- och utchecking ur systemet.  
Guest behöver instansvaribler för att lagra de uppgifter som krävs av labbspecen.

Menu-klassen visar menyn och anropar instanserna av MenuAlternative som har skapats i RubyCampings 
konstruktor. Menu, MenuAlternative är inte knutna till applikationen. Menu måste spara
menymeddelandet, prompten och MenuAlternative-objekten i instansvariabler.

Input-klassen hjälper till vid inmatning. Eftersom alla metoder är klassvariabler och 
tillståndslösa behöver vi inte spara några tillstånd.

Diskussion: 
Konstruktorn för RubyCamping innehåller ganska mycket applikationsspecifik logik. Alternativt,
skulle man kunna flytta de block som representerar olika menyalternativ till sina egna klasser:
t.ex. CheckingOutMenu. Men som jag har lärt mig OO så ska klasserna vara generella typer av 
objekt, dvs. de ska inte innehålla några specifika data. Det ska instanserna göra. Nu blir ju
i och för sig konstruktorn för stor, men jag tror att det är bra att ha en klass som har hand om
det applikationsspecifika och se till att de andra är så generella som möjligt. Det är så jag är
van vid att göra program i Java.

Man skulle också kunna göra @plots i RubyCamping till en localvariabler instället för en
instansvariabel eftersom den bara behövs i en funktion (closures tar hand om resten). Men 
för konsistens lämnade jag den som en instansvariabel.

Ur ett designmässigt perspektiv ser jag inte något behov utav mer klasser eftersom ultimat ska
de respektera objekt i den verkliga världen och då vi inte har flera saker på campingplatsen så
borde det räcka.

Klasser:
  RubyCamping - Huvudklassen som knyter samman alla delar
    @guests - Samling av alla gäster som någonsin har checkat in. Adressbok.
    @plots - Samling som representerar alla 32 tomtplatser med referenser till e.v. tillhörande gäster

    main_loop - Visar menyn och anropar menyval

    add_first_guests - Lägger till de 5 st. gäster som måste finnas med vid programmets uppstart

  Plot - Representerar en tomtplats, har referens till gästen som bor på den platsen
    @number - tomtnummer, publik läsning
    @gauge - instans av Electricity, publik läsning för att användas vid utcheckning
    @guest - referens till gästen som nu bor på tomten
     
  Guest - Representerar en gäst, har logik för incheckingning och utcheckning
    De flesta fälten är lika från förra versionen
    @energy_consumed - publik läsning behövs vid utcheckningen för att uppdatera mätarställning
    @firstName, @lastName, @adress - publik läsning behövs för att jämföra objekt

    check_in - Läser in datan för en gäst från tangentbordet. Tar platsnummer och elmätarvärde som parameter
    check_out - Läser in tillägsdata för utchecking och beräknar elkonsumtion

    set_info - Används för att ge värden till gästinstanser utan att läsa in från användaren. Används bara för de 5 första gästerna.

    print_short - Skriver ut adressuppgifter
    print_long - Skriver ut alla uppgifter
    print_selection - Skriver ut uppgifterna till utcheckningsmenyn

  Electricity - Har hand om mätarställningen vid en viss plats
    increase - Lägg till elkonsumtionen till mätarställningen

  Input - Hjälpklass där alla inläsningsfunktioner ligger som klassmetoder
    print_error_and_wait - Visar ett felmeddelande och väntar på att 
                           användaren ska bekräfta att hon läst det
    checking_in - Sköter incheckningen av en gäst 
    checing_out - Skriver bara ut gästens information och avslutar programmet
    read_multi_string - Läser in flera rader tills användaren skriver '.' på
                        en egen rad
    read_string - Läser in en sträng/rad  
    read_phone - Läser in ett telefonnummer som måste ha riktnummer
    read_date - Läser in ett datum
    
    read_number - Läser in ett nummer 

  Menu - Generell klass som har hand om menyn
    do_menu - Här ligger huvudloopen

  MenuAlternative - Kapslar in ett block i en klass. Hård kopplad till Menu.
    do_selection - Anropar blocket 


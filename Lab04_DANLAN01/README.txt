RubyCamping
Program för administration av Ruby Camping
Version 4
Av: Daniel Lännström

Användning:
Starta programmet i konsolen med ruby main.rb
Välj menyalternativ i huvudmenyn och följ de interaktiva instruktionerna.

Systembeskrivning:
Programmet kan hantera olika typer av uthyrning (stuga, husvagn, husbil,
tält). All data sparas i en databas. 

Kostnad för besöket räknas ut vid utcheckning. Man kan även få en lista
över transaktioner och få en summering av intäkterna på Ruby Camping.

I statistik-menyn kan man skriva ut ekonomirapporten till en fil eller
få ut addresslistan till en fil.

Användaren kan trycka EOF (Ctrl-D) för att avbryta och komma tillbaka till menyn.

config.rb innehåller konstanter för att enklare kunna lägga till ytterligare
uthyrningsklasser. Ändra denna fil för att ställa in databasuppgifter.

Översikt:
Jag har valt att behålla den interna strukturen och ladda in datan från databasen
vid uppstart och sen se till att den uppdateras när de interna datastrukturerna
uppdateras. Det enda undantaget är GuestList som kör en SQL-förfrågan varje gång
den används.

Relativt lite ändring av klass-strukturen var nödvändig. Jag la till en metod som
laddade in datan från databasen från en nyckel och anroppade den från konstruktorn.

Diskussion:
Jag har valt att ha en tabell för kunddatan som är knuten till person(namn, address)
annan tabell för datan som är knuten till vistelsen (ankomstdatum, avresedatum etc).
Anledningen är att jag vill undvika redudans i databasen. Genom att se till att data
som är oberoende av varandra i den verkliga världen också är oberoende av varandra i
databasen blir det enklare att underhålla den. Man kan ju tänka sig att samma kund 
bor på Ruby Camping flera gånger per år. Alternativt skulle man kunna lagra en rad 
för varje vistelse i en Guest-tabell men denna lösningen känns inte helt korrekt 
enligt mig.

Databas-schema:
Det mesta här borde vara ganska straigh-forward det enda som krävde lite tänk var 
uppdelningen av datan i Guest-klassen i tabellerna Customers och Stay för ökad
flexibilitet.

    Cabin - tabell som representerar Cabin-klassen
        name - namnet
        customerID - nyckel in i Customers om det finns en gäst i denna stuga annars NULL
    Customers - 
        id - unik id
        firstName - förnamn
        lastName - efternamn
        adress - adress
        phone - telefon
    EconomyPost
        id - unik id
        type - symbol som talar om vilken subklass denna post har
    ElectricityEconomyPost - fält precis samma som klass med id 
    RentEconomyPost - fält precis samma som klass fast med ett fält för id
    PriceListEntry - fält precis samma som klass fast med ett fält för id
    Plot
        id - platsnummer
        customerID - nyckel in i Customers om det finns en gäst på denna tomt annars NULL
        gauge - mätarställning (uppdateras bara när en gäst checkar ut)
    Stay
        customerId - nyckel in i Customers
        arrival - ankomsdatum (sparad som sträng tyvärr)
        departure - NULL om det är en aktuell gäst annars 
        type - symbol som 
        plotID - tomtNUMMER (id) om det är en tomtplats annars NULL om det är en stuga
        cabinID - NULL om det är en tomtplats, tomtNAMN om det är stuga
        payment_plan - NULL om det är en tomtplats, betalningsplan om det är en stuga
        electricty - vill gästen ha el? om det är en tomtplats, om det är en stuga NULL

Klasser Förändringar:
    EconomyPost
        load_from_db - dispatch på typen från databasen
    ElectricityEconomyPost - konstruktorn laddar in ett objekt från databasen om id är angivet
    RentEconomyPost - samma här

    Plot
        load_from_db - laddar in ett Plot med ett givet nummer
        check_in - ser till sätta customerID i Plot-tabellen
        check_out - NULL:ar i customerID i Plot-tabllen

    PlotGuest
        load_guest - statistk hjälpfunktion för att skapa ett Guest-objekt från databasen givet ett id
        load_from_db - själva koden som laddar in från databasen
        do_check_in - lägger till en rad i Stay-tabellen som representerar vistelsen
        check_out - ser till att updatera mätarställningen, sätter ett avresedatum i databasen samt anropar Plot#check_out

    Cabin   
        load_from_db - laddar ett objekt från databasen givet stugans namn
        check_in - updaterar Cabin-tabellen
        check_out - updaterar Cabin-tabellen 

    CabinGuest - analogt till PlotGuest

    Guest
        already_present - ser till att bara en kund bara kan vara inchecka en gång i taget
        check_in - frågar nu efter kundnummer
        load_customer_from_db - laddar in kunddata från Customers-tabellen
        get_last_id - hämtar den sista använda id:et i databasen så vi kan räkna ut nästa att använda
        insert_new_customer - lägger till en ny kund i databasen

    PriceListEntry
        value= - ser till att när objektet ändras, så uppdateras motsvarande rad i databasen

    PriceList
        load_from_db - laddar in alla id:n och skickar vidare till konstruktorn för PriceListEntry

    GuestList 
        each - loopar över raderna i Customers-tabellen

    RubyCamping
        setup_db - öppnar en global databas-anslutning
        close_db - stänger den globala databas-anslutningen

    StatisticsMenu - ny klass som har hand om statistikmenyn

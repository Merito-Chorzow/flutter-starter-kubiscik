Zakres funkcjonalny
Natywna funkcja

Pobieranie lokalizacji GPS użytkownika

Wykorzystano pakiet geolocator

Obsługa:

braku uprawnień

braku danych lokalizacyjnych

komunikatów błędów

Uzasadnienie wyboru:
Lokalizacja GPS jest jedną z najczęściej wykorzystywanych funkcji natywnych w aplikacjach mobilnych, szczególnie w aplikacjach mapowych, dziennikach podróży i notatkach kontekstowych.

Komunikacja z API

Operacja POST — zapis nowego wpisu

Operacja GET — pobranie listy wpisów
Logika komunikacji z API została wydzielona do warstwy serwisów.

Widoki aplikacji
1. Lista wpisów

lista wszystkich zapisanych wpisów

wyświetlane informacje:

tytuł

data utworzenia

stan pusty: komunikat o braku wpisów

przycisk dodania nowego wpisu

2. Dodaj wpis

formularz zawierający:

tytuł

opis

przycisk pobrania lokalizacji GPS

walidacja danych:

brak możliwości zapisu bez tytułu

brak możliwości zapisu bez lokalizacji

komunikaty o błędach

3. Szczegóły wpisu

pełny opis wpisu

data utworzenia

współrzędne geograficzne (jeśli dostępne)

Nawigacja

nawigacja pomiędzy widokami z wykorzystaniem Navigator

przekazywanie danych pomiędzy ekranami

powrót z widoku dodawania przekazuje nowy wpis do listy

UX i obsługa stanów

stan pusty listy wpisów

walidacja formularza

komunikaty błędów (SnackBar)

blokada zapisu bez wymaganych danych

czytelny interfejs oparty o Material Design 3

Testowanie

Aplikacja była testowana lokalnie na:

Windows (desktop)

Sprawdzone scenariusze:

dodanie wpisu z lokalizacją GPS

zapis i wyświetlenie wpisu na liście

próba zapisu bez tytułu

próba zapisu bez lokalizacji

Technologie

Flutter

Dart

Material Design 3

Geolocator

HTTP
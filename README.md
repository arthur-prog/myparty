# MyParty

A Flutter / Firebase app where you can create, join and manage parties.

## Getting Started

Create a `.env` file in the root of the project.

```
GOOGLE_MAPS_API_KEY="YOUR_API_KEY"
```

If you don't have a Google api key, in the file `lib/src/features/screens/home/home_screen.dart` at line 75, you can replace 


```
const MapScreen(),
```

by

```
const Scaffold(),
```

## This app hasn't already been tested on iOS!

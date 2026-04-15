# 🗺️ Map Feature Integration Guide

This guide explains how the Frontend Teams (Flutter & React) should implement the Internship Map feature.

The goal of this feature is to show students companies, factories, hospitals, and offices near them where people from their field work. These are **not** guaranteed open positions, but rather realistic places where they could apply for internships or shadow professionals.

## 1. The UX Flow

The app has a navigation bar at the bottom. One of the tabs is the **Map Tab**. 

### When the user opens the Map Tab:
1. Show a loading state (spinner over an empty map or skeleton UI).
2. Call `GET /api/v1/map/profile-companies`.
3. Render the returned companies as pins on the map.
4. (Optional) Group pins into clusters if there are too many in one area.

### When the user taps a Pin:
1. Show a bottom sheet or a popup card with the company name, sector, and a short description.
2. (Optional) Fetch additional details using `GET /api/v1/map/companies/{id}` if you need more info (though the list endpoint returns a lot already).

---

## 2. API Endpoints

### 📍 The Main Endpoint (Auth Required)
This is the only endpoint you really need to build the tab. It automatically reads the student's profile (from their onboarding session) and returns relevant places.

```http
GET /api/v1/map/profile-companies?radius_km=50&live=false
Authorization: Bearer <token>
```

**Query Parameters:**
- `radius_km` (optional, default 50.0): How far from their home wilaya to search.
- `live` (optional, default false): Set to `true` to also query OpenStreetMap in real-time. This adds ~2 seconds to the request but returns *many* more local businesses. Use `false` if you want a fast, curated list of major employers only.

**Response Map Array (`companies`):**
```json
{
  "companies": [
    {
      "id": "sonatrach",
      "name": "Sonatrach",
      "name_ar": "سوناطراك",
      "type": "state_company",
      "domains": ["engineering", "science", "technology"],
      "relevant_majors": ["petroleum_engineering", "geology"],
      "wilaya_code": 16,
      "commune": "Hydra",
      "address": "Djenane El Malik, Hydra, Alger",
      "coordinates": {
        "lat": 36.7488,
        "lng": 3.0451
      },
      "description": "Algeria's national oil and gas company...",
      "internship_likelihood": "high",
      "tags": ["petroleum", "energy", "engineering", "research"],
      "distance_km": 12.4,
      "source": "static"
    }
  ],
  "total": 1,
  "filters_applied": {
    "domains": ["engineering", "science"],
    "wilaya_code": 16,
    "radius_km": 50.0,
    "include_live_data": false,
    "static_count": 1,
    "live_count": 0,
    "auto_resolved_from_profile": true
  },
  "center": {
    "lat": 36.7367,
    "lng": 3.0869
  },
  "radius_km": 50.0
}
```

---

### 🗺️ Public Search (No Auth)
If you build a feature where users can explore *other* fields or search manually:

```http
GET /api/v1/map/companies?domains=technology,engineering&wilaya=16&live=true
```

---

### 📊 Heatmap / Overview (Optional)
If you zoom out to view all of Algeria, you can show markers with the number of companies per wilaya.

```http
GET /api/v1/map/wilayas/stats?domains=engineering
```

---

## 3. UI/UX Recommendations for the Map

### Pin Colors by Sector
The `companies` array returns a `domains` list. You can color-code your map pins:
- 🔵 **Technology / IT**: Blue
- 🔴 **Engineering / Manufacturing**: Red/Orange
- 🟢 **Medicine / Pharma**: Green
- 🟡 **Business / Finance**: Yellow
- 🟣 **Law / Government**: Purple
- 🌱 **Agriculture**: Dark Green

### The `source` Field
Companies have a `source` field:
- `"static"`: Major, curated Algerian companies (e.g. Sonatrach, Djezzy, Cevital, CHU Mustapha). High quality, verified data.
- `"overpass"`: Live data pulled from OpenStreetMap (e.g. a local clinic, a local software agency). 

Consider giving curated (`"static"`) companies a slightly larger pin or a "verified" badge in the UI.

### The `internship_likelihood` Field
For static companies, you will see `internship_likelihood` (`very_high`, `high`, `medium`, `low`). You could use this to rank companies in a list view next to the map, or sort the bottom sheet details.

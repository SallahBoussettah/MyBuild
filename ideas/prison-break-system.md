# RedM Roleplay Server - Prison Break System

## Overview
This system implements a realistic prisoner transport and prison break mechanic. Criminals are first detained in Valentine for 1 day, then transported to Strawberry for a 3-day sentence. During their time in Strawberry, other players can organize a prison break by destroying a jail wall, leading to an intense escape sequence and town-wide combat.

## System Workflow

### 1. Arrest & Initial Detention (Valentine)
- Sheriffs can arrest players with criminal status/wanted level
- Arrest includes animation sequence and handcuffing mechanics
- Prisoner is logged in jail database with timestamp for 1-day Valentine sentence
- Countdown timer visible to prisoner in UI
- Basic jail activities available to reduce sentence time

### 2. Prisoner Transport
- After 1 day, scheduled transport event triggers automatically
- All online sheriffs receive notification to escort prisoner
- Predefined transport route from Valentine to Strawberry
- Transport requires minimum 2 sheriff escorts
- Ambush opportunities along the route for criminal players
- Transport wagon has health system that can be damaged

### 3. Strawberry Detention
- 3-day sentence timer begins upon arrival at Strawberry jail
- Cell assignment system with limited capacity
- Prisoner activities/jobs to reduce sentence time
- Limited interaction with outside world through visitors
- Meal times and schedule to maintain immersion

### 4. Prison Break Mechanics
- Designated weak point in jail wall, visually marked with subtle cracks
- Special explosives required (craftable/purchasable by non-prisoners)
- Explosives must be delivered near the marked wall section
- Detonation triggers server-wide alert for all law enforcement
- Notification system informs all players of prison break in progress
- Cooldown period between break attempts (server-configurable)

### 5. Escape Sequence
- Wall destruction features realistic animation and sound effects
- Multiple escape path options from jail
- Automated NPC law enforcement response in addition to player sheriffs
- Response scaling (more police spawn as time passes without recapture)
- Reward/penalty system for successful/failed escapes
- Getaway vehicles/horses can be prepared by accomplices

### 6. Post-Break Consequences
- Escaped prisoners receive increased wanted level (server-configurable)
- Temporary "lockdown" state for Strawberry town with increased law presence
- Bonus reward for sheriffs who recapture escapees
- Repair period for damaged jail (creates cooldown for next break attempt)
- Economic impact on town (higher store prices, reduced civilian NPCs)

## Technical Requirements
- Database storage for prisoner records and sentences
- Timer system for tracking sentence duration
- Event triggers for transport and break scenarios
- Town state management system
- UI elements for prisoner status and alerts
- Coordinate mapping for jail weak points
- Animation and sound effect integration 
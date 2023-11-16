[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Made For B&R](https://github.com/hilch/BandR-badges/blob/main/Made-For-BrAutomation.svg)](https://www.br-automation.com)

# mappView Demo for ACOPOStrak

With this Automation Studio project, we want to show how diagnostics can be built for an ACOPOStrak system.

Demonstrating the capabilities of the ACOPOStrak system was not the main focus.

mappView, mappAlarm, the system logger and the system dump are the key components.


## Visualization
The mappView 'WebViewer' widget displays the current status of the shuttles and segments. 
A reference to the shuttle identifiers in mappMotion logger can be established via the displayed identifiers.
mappAlarm is the basic of the alarm handling.

## SystemLogger
the system logger for mappMotion is extended with user loggers to record internal states (parameters, state machines etc.).
Through this the shuttle movements can then be assigned to the internal states of the application.

## Flight recorder
in case of an crash the shuttle movements of the last few seconds are recorded into (pseudo video in HTML file) and furthermore a system dump is created which contains all hardware information and loggers.
Both can be uploaded or copied to external storages.

# Usage

Install on ArSim (or real Hardware) then open browser with
```
http://<IP-address>:81
```

The project requires the following file structure:
```
F:\
  +-- \web
  |
  +-- \web\SvgData
  |
  +-- \web\Diagnosis
```

for this, this project includes a folder 'USER' which must can transferred via an 'Initial installation' when the project is installed for the first time.


![force_initial_installation](/doc/force_initial_installation.png)

(when using ArSim this is done by an 'Offline installation')

# Pages

## Home

still empty

## Diag

![page_diag](/doc/page_diagnosis.png)


## File Explorer

![page_file_explorer](/doc/page_file_explorer.png)


## SDM

![page_sdm](/doc/page_sdm.png)


## Settings

![page_settings](/doc/page_settings.png)


## Alarm Page

![page_alarm](/doc/page_alarm.png)



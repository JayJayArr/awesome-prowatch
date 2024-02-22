REM This Batch file starts the Schindler Exporter and restarts it shortly before one our elapses
@echo off
start C:\Schindler\SIDExporter\Exporter.exe
timeout /t 3595 >null
taskkill /f /im Exporter.exe >nul
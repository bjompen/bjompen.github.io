$MyProjectName = 'AZDO.XPLAT.TASK' 

# Create oriject folder
New-Item $MyProjectName -ItemType Directory
Push-Location $MyProjectName

# Create package.json
npm init -y

# Add node / TS dependendencies
npm install azure-pipelines-task-lib --save
npm install @types/node --save

# Create .gitignore
Pop-Location
"node_modules`r`n*.vsix" | Out-File .gitignore

# Initialise Typescript project
Push-Location $MyProjectName
tsc --init --target es6

# Create your index.ts file
New-Item index.ts

# Create your task.json
New-Item task.json

# Create vss-extension.json extension manifest
Pop-Location
New-Item vss-extension.json

# Compiling our typescript
Push-Location $MyProjectName
Get-ChildItem index.js -ErrorAction SilentlyContinue | Remove-Item -ErrorAction SilentlyContinue
& tsc

# Compiling our VSIX file
Pop-Location
Get-ChildItem *.vsix | Remove-Item
& tfx extension create --manifest-globs .\vss-extension.json
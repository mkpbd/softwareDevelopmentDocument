

1. **Project Management Commands**
**Create a new project**:
 ```cmd
 dotnet new <TEMPLATE>
 dotnet new console
```

2. **List all available templates**:

```cmd
dotnet new list

```

3. **Restore project dependencies**:
```cmd
dotnet restore

```
4. **Build the project**:
```cmd
dotnet build

```

5. **Run the application**:

```cmd
dotnet run

```

6. **Solution Management Commands**
 **Create a new solution**:
```cmd
dotnet new sln
```

7. **Add a project to a solution**:
```cmd
dotnet sln add <PROJECT_PATH>
dotnet sln list

```
8. **List projects in the solution**:
```cmd
dotnet sln remove <PROJECT_PATH>

```

3. **Package Management**
   **Add a NuGet package to the project**:
```cmd
dotnet add package <PACKAGE_NAME>

```
**List installed packages**:
```cmd
dotnet list package

```
### 4. **Testing Commands**

- **Create a new test project**:
```cmd
dotnet new xunit  # or `nunit` or `mstest`

```

**Run tests**:
```cmd
dotnet test

```

### 5. **Publishing**

- **Publish the application for deployment**:
```cmd
dotnet publish

```
**Publish with specific configuration (e.g., Release)**:
```cmd
dotnet publish -c Release

```
### 6. **Global Tools**

- **Install a global tool**:
```cmd
dotnet tool install -g <TOOL_NAME>

dotnet tool list -g

```

**Update a global tool**:
```cmd
dotnet tool update -g <TOOL_NAME>

```

**Uninstall a global tool**:
```cmd
dotnet tool uninstall -g <TOOL_NAME>

```
### 7. **Version Information**

- **Display .NET SDK version**:
```cmd
dotnet --version

```
**Display detailed information about the installed .NET SDKs and runtimes**:
```cmd
dotnet --info

```

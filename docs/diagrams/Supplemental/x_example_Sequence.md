# [Example] Sequence

```plantuml

@startuml
!include <C4/C4_Sequence>

Container(c1, "Single-Page Application", "JavaScript and Angular", "Provides all of the Internet banking functionality to customers via their web browser.")

Container_Boundary(b, "API Application")
  Component(c2, "Sign In Controller", "Spring MVC Rest Controller", "Allows users to sign in to the Internet Banking System.")
  Component(c3, "Security Component", "Spring Bean", "Provides functionality Related to signing in, changing passwords, etc.")
Boundary_End()

ContainerDb(c4, "Database", "Relational Database Schema", "Stores user registration information, hashed authentication credentials, access logs, etc.")

Rel(c1, c2, "Submits credentials to", "JSON/HTTPS")
Rel(c2, c3, "Calls isAuthenticated() on")
Rel(c3, c4, "select * from users where username = ?", "JDBC")

SHOW_LEGEND()
@enduml

```

This is an example from MIT code from the C4 stdlib plugin.
https://github.com/plantuml-stdlib/C4-PlantUML/blob/master/samples/C4_Sequence%20Diagram%20Sample%20-%20bigbankplc.puml
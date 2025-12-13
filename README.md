
## Summary

I decided to use an MVVM approach for loading the JSON data and populating it into SwiftUI Lists. This allows the API layer and data persistence to all be abstracted out of the UI code. 
This makes for more modular integration and makes the main data model agnostic to the screen it's providing data to. 

I chose to focus on the decoders and data layer first before building the UI and used some of my own error and custom alert handling to debug as I was building it. 
You'll be able to see this in my repo's commit history.

## Architecture & Design Decisions

UI
	•	Built with SwiftUI using default system components (List, NavigationStack, Text)
	•	Minimal customization was applied only where explicitly annotated the instructions
  •	I only diverted from default UI controls where without doing so, the appearance diverged too much from the provided screen mock

Data & Persistence
	•	Networking is handled via URLSession using async/await
	•	If cached data exists and decodes successfully
	•	Otherwise, fetch from network, load, then save locally.
	•	I chose to do save the JSON directly in the App sandbox over Core Data or SwiftData to keep the solution simple and appropriate for a read-only feed

Models
	•	Data models use Codable with custom decoding logic to handle:
	•	ISO8601 timestamps with fractional seconds
	•	mixed int/double/string types in the JSON
  

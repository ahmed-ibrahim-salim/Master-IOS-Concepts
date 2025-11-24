# 📸 Flickr Image Search App: Implementation and Learning Plan

This plan follows a Vertical Slicing approach, ensuring a working, shippable product at the end of each phase.

## Phase 1: MVP (Minimal Working App)

### 🎯 Goal: Core Functionality (Search, Fetch, Display)

| Task/Concept Focus     | Implementation Plan                                                               | Essential Learning Topics & Resources                                                                     |
| :--------------------- | :-------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- |
| **Foundation Setup**   | Models, Services, ViewModels, and basic file structure.                           | **SwiftUI Data Flow:** `@StateObject`, `@Published`, and `ObservableObject` protocol.                     |
| **Basic Search Input** | Functional `TextField` bound to `viewModel.searchText`.                           | **SwiftUI View Basics:** Using `VStack`, `TextField`, and basic modifiers.                                |
| **Network & Parsing**  | Use `URLSession` data task publisher for API calls. Parse JSON using `Decodable`. | **Codable in Swift:** Handling nested JSON (like the Flickr response) and custom `Decodable` conformance. |
| **Basic Results List** | Display `PhotoItem`s in a `LazyVGrid`.                                            | **SwiftUI Layout:** Using `ScrollView`, `LazyVGrid`, and `ForEach`.                                       |
| **Basic States**       | Implement `isLoading` and basic error messages (`String?`).                       | **Error Handling:** Using `do-catch` with throwing functions and creating custom `Error` enums.           |

## Phase 2: Performance & UX

### 🎯 Goal: Responsive Interaction and Smooth Loading

| Task/Concept Focus      | Implementation Plan                                                    | Essential Learning Topics & Resources                                                                                           |
| :---------------------- | :--------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------ |
| **Debounce Search**     | Apply `debounce` operator to `$viewModel.searchText`.                  | **Combine Operators:** Focus on **Time-Slicing** operators like `debounce(for:scheduler:)` for performance.                     |
| **Animate Image Load**  | Use `AsyncImage` and `.animation()` for a smooth fade-in effect.       | **SwiftUI Animations:** Reviewing `.animation()` and the difference between implicit and explicit animations (`withAnimation`). |
| **Concurrency Context** | Ensure all Combine/network results update state on the correct thread. | **Concurrency Scheduling:** Understanding `receive(on: RunLoop.main)` and thread safety for UI updates.                         |

## Phase 3: Concurrency & Advanced UI

### 🎯 Goal: Resource Management and Advanced Data Handling

| Task/Concept Focus    | Implementation Plan                                                                                     | Essential Learning Topics & Resources                                                                               |
| :-------------------- | :------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------ |
| **Image Caching**     | Implement an in-memory `NSCache` layer for downloaded images.                                           | **Image Caching Strategy:** Implementing `NSCache` and defining cache keys.                                         |
| **Prefetching**       | Use view events (like `.onAppear`) to trigger prefetching of upcoming image URLs.                       | **Structured Concurrency:** Deep dive into **`async/await`** and using **`TaskGroup`** for parallel downloads.      |
| **Task Cancellation** | Implement logic to cancel Combine subscriptions or Swift Tasks if the search query changes mid-request. | **Cancellation:** How to manage `Cancellable` objects in Combine and **`Task`** cancellation in modern concurrency. |
| **Pull-to-Refresh**   | Add pull-to-refresh functionality to the `ScrollView`.                                                  | **SwiftUI Intrinsic Behavior:** Using `.refreshable` modifier.                                                      |

## Phase 4: UI/UX Enhancements

### 🎯 Goal: Polished Interface and Dynamic Layout

| Task/Concept Focus           | Implementation Plan                                                                           | Essential Learning Topics & Resources                                                                     |
| :--------------------------- | :-------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- |
| **Dynamic Layout Switching** | Add a button to toggle between `LazyVGrid` and `LazyVStack` (grid/list).                      | **SwiftUI State:** Managing dynamic layout with `@State` and conditional views.                           |
| **Animate Transitions**      | Apply seamless transition animations during the grid/list toggle.                             | **Advanced SwiftUI:** Exploring the **`MatchedGeometryEffect`** modifier for seamless layout transitions. |
| **Custom Modifiers**         | Create custom view modifiers for consistent styling of loading indicators and error messages. | **View Protocol:** Creating custom `ViewModifier`s for reusable styling logic.                            |

## Phase 5: Combine & State Management

### 🎯 Goal: Advanced Reactive Logic

| Task/Concept Focus             | Implementation Plan                                                                                                      | Essential Learning Topics & Resources                                                                                 |
| :----------------------------- | :----------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| **Real-Time Suggestions**      | Implement a service that suggests common search terms as the user types (if available).                                  | **Combining Publishers:** Operators like `combineLatest` or `zip` for complex, multi-source state.                    |
| **Network Activity Indicator** | Use Combine to publish network activity status across the app for a global loading spinner.                              | **Subjects:** Understanding `PassthroughSubject` vs. `CurrentValueSubject` for creating and controlling data streams. |
| **Chain Publishers**           | Chain multiple publishers for complex UI state logic (e.g., disable search button unless text is valid AND not loading). | **Transformation Operators:** Reviewing `map`, `flatMap`, and filtering logic within Combine pipelines.               |

## Phase 6: Optimization

### 🎯 Goal: Performance and Stability

| Task/Concept Focus    | Implementation Plan                                                                                           | Essential Learning Topics & Resources                                                                                      |
| :-------------------- | :------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------- |
| **Memory Monitoring** | Implement logic to clear the image cache when memory warnings are received.                                   | **Instruments:** Hands-on practice with the **Allocations** instrument to find memory leaks and the **Leaks** instrument.  |
| **View Optimization** | Use profiling tools to ensure view updates are minimal and efficient.                                         | **Performance Profiling:** Using the **Time Profiler** instrument to identify slow view bodies and expensive computations. |
| **Unit Testing**      | Write unit tests for the `PhotosViewModel` covering all business logic, error handling, and Combine pipeline. | **Testing View Models:** Mocking dependencies and testing Combine publishers (e.g., using `XCTestExpectation`).            |

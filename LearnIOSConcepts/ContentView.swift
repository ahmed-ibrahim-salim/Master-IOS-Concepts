//
//  ContentView.swift
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 02/08/2025.
//

import Combine
import SwiftUI

// MARK: Service

struct FlickrService {
    enum FlickrError: Error {
        case path
        case url
    }

    private var path: String { "https://api.flickr.com/services/rest" }

    // Helper method (DO NOT MODIFY)
    func buildUrl(searchQuery: String) throws -> URL {
        guard var components = URLComponents(string: path)
        else { throw FlickrError.path }
        components.queryItems = [
            URLQueryItem(name: "text", value: searchQuery),
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "a724969f016f0b8badd7e518a6c48e55"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "extras", value: "url_t"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
        ]
        guard let url = components.url
        else { throw FlickrError.url }
        return url
    }
}

// MARK: Models

struct PhotosMainResponse: Decodable {
    let photos: PhotosResponse?
}

struct PhotosResponse: Decodable {
    let photo: [PhotoItemResponse]
}

struct PhotoItemResponse: Decodable {
    let id: String
    let url_t: String
    let title: String

    func toPhoto() -> PhotoItem {
        PhotoItem(id: id, url: URL(string: url_t)!, title: title)
    }
}

// MARK: DTOs

struct PhotoItem: Identifiable {
    let id: String
    let url: URL
    let title: String
}

// MARK: View model

class PhotosViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var photos: [PhotoItem] = []
    @Published var error: String? = nil
    @Published var searchText: String = "" // Add searchText for binding
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.search(query: text)
                } else {
                    self.photos = []
                    self.error = nil
                }
            }
            .store(in: &cancellables)
    }

    func search(query: String) {
        isLoading = true
        error = nil

        do {
            let url = try FlickrService().buildUrl(searchQuery: query)

            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { element -> Data in
                    guard let reponse = element.response as? HTTPURLResponse, reponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: PhotosMainResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] element in
                    guard let self = self else { return }
                    switch element {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.isLoading = false
                    }
                }, receiveValue: { [weak self] element in
                    guard let self = self else { return }
                    guard let repsonse = element.photos else {
                        self.error = "No photos found."
                        self.isLoading = false
                        return
                    }
                    self.photos = repsonse.photo.map { $0.toPhoto() }
                    self.isLoading = false
                })
                .store(in: &cancellables)

        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
}

// MARK: View

// 

struct ContentView: View {
    @FocusState private var isSearchFieldFocused: Bool
    private let columns = [
        GridItem(.fixed(120), spacing: 10),
        GridItem(.fixed(120), spacing: 10),
        GridItem(.fixed(120), spacing: 10),
    ]
    @StateObject private var viewModel: PhotosViewModel
    @State private var selectedPhoto: PhotoItem? = nil

    init() {
        _viewModel = StateObject(wrappedValue: PhotosViewModel())
    }

    var body: some View {
        ZStack {
            VStack {
                Text("Search Images")
                    .font(.headline)
                TextField("Search", text: $viewModel.searchText)
                    .focused($isSearchFieldFocused)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .onSubmit {
                        print("submitted")
                    }
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                }

                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center
                    ) {
                        ForEach(viewModel.photos) { photo in
                            ImageItem(photo: photo)
                                .onTapGesture {
                                    selectedPhoto = photo
                                }
                        }
                    }
                }
            }
            if viewModel.isLoading {
                VStack(alignment: .center) {
                    ProgressView()
                        .controlSize(.extraLarge)
                }
            }
        }
        .sheet(item: $selectedPhoto) { photo in
            PhotoDetailView(photo: photo)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

// MARK: Subviews

struct ImageItem: View {
    let photo: PhotoItem
    @State private var isLoaded = false

    var body: some View {
        VStack {
            AsyncImage(url: photo.url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .opacity(isLoaded ? 1 : 0)
                        .animation(.easeIn(duration: 1), value: isLoaded)
                        .onAppear {
                            isLoaded = true
                        }
                case .failure:
                    Color.gray
                        .frame(height: 120)
                case .empty:
                    ProgressView()
                        .frame(height: 120)
                @unknown default:
                    ProgressView()
                        .frame(height: 120)
                }
            }
            .clipShape(.rect(cornerRadius: 10))
            .frame(height: 120)

            Text(photo.title)
                .lineLimit(1)
        }
    }
}

// MARK: Detail view

struct PhotoDetailView: View {
    let photo: PhotoItem
    var body: some View {
        VStack {
            AsyncImage(url: photo.url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Color.gray
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }

            Text(photo.title)
                .font(.headline)
                .padding()
        }
        .padding()
    }
}

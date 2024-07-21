# Bloc State Management in Flutter

Bloc (Business Logic Component) is a powerful state management solution in Flutter was lunched as on of the first solution as a part of flutter ecoSystem. Initially introduced by Google as a `DESIGN PATTERN`, it aims to manage business logic and state in a clean, scalable, and testable way. This pattern helps separate the presentation layer from the business logic, making the code more maintainable and reusable.

<img src="https://github.com/Yacine300/bloc_cubit_course/blob/main/cover.png" alt="BlocApp" />

## Memory and State Management

In Flutter, state management is crucial to ensure that the application's user interface (UI) responds efficiently to user interactions and data changes. Bloc achieves this through the use of `STREAMS`, which are a core part of Dart's asynchronous programming model.

### Immutability

Immutability is a key concept in Bloc state management. When the state is immutable, it means that once a state object is created, it cannot be modified. Instead of modifying an existing state, a new state object is created and emitted. This approach has several benefits:

1. **Predictability**: Since states are immutable, you always know the state of your application at any given time. This makes debugging easier because you can trace back through the state changes to understand how the current state was reached.
2. **Consistency**: By ensuring that state objects do not change, you avoid unexpected side effects that can occur when multiple parts of the application modify the state simultaneously. This leads to a more stable and reliable application.
3. **Performance**: Immutable states can be efficiently compared, which helps in optimizing the rebuilds of widgets. When a state change occurs, Flutter can quickly determine if the new state is different from the previous state, minimizing unnecessary UI updates.

## Cubit: A Lightweight Version of Bloc

Cubit is a simplified version of Bloc that provides a more automatic straightforward way to manage state without the need to deal with events. While Bloc uses events to trigger state changes manually, Cubit works with functions, making it easier to understand and use for simpler state management needs.

### Streams in Bloc and Cubit

Both Bloc and Cubit rely on `STREAMS` to manage state. Streams allow the application to listen to changes in the state and update the UI accordingly. Here's how they work:

- **Bloc**: In Bloc, events are added to an event stream. The Bloc listens to these events and maps them to new states, which are then emitted to the state stream. Widgets can listen to this state stream and rebuild when the state changes.
- **Cubit**: In Cubit, state changes are triggered by calling functions directly. These functions then emit new states to the state stream. Similar to Bloc, widgets can listen to the state stream and rebuild accordingly.

## Detailed Example

#### Bloc Example

# Use Cases for Bloc and Cubit

## Bloc: A 100% Manual Solution
Bloc is like a highly customizable manual solution for state management in Flutter. It requires you to define events, states, and how events map to states. This allows for fine-grained control over the state transitions and is ideal for complex scenarios where multiple events and state changes need to be handled meticulously.

### Example Use Cases for Bloc : 
- Form Validation: Managing the state of multiple form fields, validating inputs, and handling submission events. For example, in a multi-step form, each step can be represented by an event, and the form's state can be updated based on the validation results of each step.
Authentication: Handling login/logout events, managing user sessions, and maintaining authentication states. Different events like LoginRequested, LoginSucceeded, and LoginFailed can be used to manage the state transitions during the authentication process.
- Data Fetching: Managing the state of data fetching operations, handling loading and error states, and updating the UI based on data changes. Events like FetchData, FetchDataSuccess, and FetchDataError can be used to manage the state of data retrieval operations.
- Cubit: A More Automatic Solution
Cubit is like a more automatic solution for state management in Flutter. It simplifies the process by removing the need to define events. Instead, you work with functions that directly emit new states. This makes Cubit easier to understand and use for simpler state management needs.

### Example Use Cases for Cubit
- Counter: A simple counter application where the state is just an integer value that increments or decrements. This can be managed with functions like increment and decrement that update the state directly.
- Toggle Buttons: Managing the state of toggle buttons, such as enabling/disabling features or switching themes. For example, a Cubit can be used to manage the state of a dark mode toggle button.
Single Data Fetch: Fetching data from an API and updating the UI based on the fetched data, without complex event handling. For example, a Cubit can be used to manage the state of a simple API call that fetches user details and updates the state with the fetched data.
- Showing SnackBars or Pop-up Messages: Using listenable to show snack bars or pop-up messages based on state changes. We will discuss this `listenable` in more detail later.

## Analogy: Bicycle vs. Spaceship
Think of Bloc and Cubit as two different ways to travel. If you can go to a store and buy something by bicycle, why would you choose a spaceship to do so?

#### Bloc: 
Imagine Bloc as a spaceship. It's powerful and can handle complex journeys through space with multiple checkpoints (events). However, it's more complicated to operate and requires careful planning.
#### Cubit:
Now, think of Cubit as a bicycle. It's straightforward, easy to use, and perfect for a simple trip around the neighborhood. You don't need to worry about multiple controls or checkpoints; you just pedal (use functions) and go.
### Comparison Table

| Feature                  | Bloc                                      | Cubit                                    |
|--------------------------|-------------------------------------------|------------------------------------------|
| State Management         | Uses events to trigger state changes      | Uses functions to trigger state changes  |
| Complexity               | More complex, suitable for complex logic  | Simpler, suitable for straightforward logic |
| Setup                    | Requires defining events and states       | Requires defining states only            |
| Control                  | Fine-grained control over state transitions | Direct state transitions via functions   |
| Ideal For                | Complex scenarios with multiple events    | Simple scenarios with direct state changes |
| Example Use Case 1       | Form Validation                           | Counter                                  |
| Example Use Case 2       | Authentication                            | Toggle Buttons                           |
| Example Use Case 3       | Data Fetching with Loading/Error States   | Single Data Fetch                        |
| Example Use Case 4       | Complex state transitions and workflows   | Showing SnackBars or Pop-up Messages (to be discussed later) |
| Learning Curve           | Steeper due to event-state mapping        | Gentler due to direct function calls     |
| Performance              | Can handle complex state management efficiently | Efficient for simpler state management  |

## Architecture Components

### 1. **Event**

Events represent actions or triggers that initiate state changes in the BLoC. They are dispatched to the BLoC to indicate what needs to be done.

#### App Examples:
- **LoadProducts**: Triggered to load the list of products.
- **AddProduct**: Triggered to add a new product.
- **UpdateProduct**: Triggered to update an existing product.
- **DeleteProduct**: Triggered to delete a product by its ID.

**Event Definitions:**
```dart

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;

  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;

  UpdateProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final String productId;

  DeleteProduct(this.productId);
}
```

2. BLoC
The BLoC (Business Logic Component) processes incoming events and emits new states based on the business logic. It acts as a mediator between the UI and data layers.

ProductBloc

```dart

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.addProduct(event.product);
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.updateProduct(event.product);
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await productRepository.deleteProduct(event.productId);
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
```
3. Repository
The Repository abstracts data operations and provides a clean interface for the BLoC to interact with data sources. It handles CRUD operations and maintains data integrity.

ProductRepository:

```dart
class ProductRepository {
  List<Product> _products = [
    Product(
        id: DateTime.now().toString(),
        name: 'product1',
        price: 200,
        rating: 2.0)
  ];

  Future<List<Product>> getProducts() async {
    return _products;
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  Future<void> updateProduct(Product product) async {
    _products = _products.map((p) => p.id == product.id ? product : p).toList();
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((product) => product.id == productId);
  }
}
```
4. State
States represent different conditions or stages of the applications data. They are emitted by the BLoC in response to events and determine how the UI should render.

- ProductLoading: Indicates that data is being loaded.
- ProductLoaded: Contains a list of products fetched successfully.
- ProductError: Contains an error message if something goes wrong.

ProductState:

```dart

abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String error;

  ProductError(this.error);
}
```
### Relationships and Why ?

#### Events to BLoC:
Events are dispatched to the BLoC to signify actions that need to be taken (e.g., load, add, update, or delete products). They serve as the entry point for processing logic within the BLoC.

#### BLoC to Repository:
The BLoC interacts with the Repository to perform data operations. When an event is processed, the BLoC calls the appropriate methods on the Repository to manipulate or fetch data.

#### Repository to BLoC:
The Repository provides methods to access and modify the data, encapsulating the data management logic. It allows the BLoC to focus on processing events and managing state rather than dealing with data source specifics.

#### BLoC to State:
After processing an event and interacting with the Repository, the BLoC emits a new state. The state reflects the result of the event processing, such as whether the products are successfully loaded or if an error occurred. This state is used to update the UI accordingly.

#### State to UI: 
The UI listens for state changes and updates its presentation based on the current state. For example, it displays a loading indicator when the state is ProductLoading, shows the list of products when the state is ProductLoaded, or displays an error message when the state is ProductError.

# BLoC Pattern in Flutter - Components and Comparison

This document provides an overview of key components in the BLoC (Business Logic Component) pattern and their use cases. It also includes a comparison between `BlocBuilder`, `BlocConsumer`, and `BlocSelector`.

## Architecture Components

### 1. **BlocProvider**

**`BlocProvider`** is a widget that provides an instance of a `Bloc` or `Cubit` to its child widgets. It manages the lifecycle of the BLoC and ensures it is available to the widgets that need it.

#### Usage:

```dart
BlocProvider(
  create: (context) => ProductBloc(ProductRepository()),
  child: YourWidget(),
);
```
## Key Points:

- Creates and provides a Bloc or Cubit instance.
- Automatically disposes of the Bloc when the BlocProvider is removed from the widget tree ( # remember ).
- Ensures a Bloc is available to a subtree of widgets ( scoop ).



### 2. **MultiBlocProvider**
MultiBlocProvider allows you to provide multiple Bloc or Cubit instances to a subtree of widgets. It is a collection of BlocProvider widgets.

#### Usage:
```dart

MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => ProductBloc(ProductRepository())),
    BlocProvider(create: (context) => AnotherBloc(AnotherRepository())),
  ],
  child: YourWidget(),
);
```
## Key Points:

- Provides multiple Bloc or Cubit instances.
- Useful for managing multiple state objects within a single subtree.
- Keeps the widget tree organized.

### 3. **MultiBlocProvider**
BlocBuilder builds itself based on the current state of a Bloc or Cubit. It rebuilds its child widgets whenever the state changes.

#### Usage:
```dart

BlocBuilder<ProductBloc, ProductState>(
  builder: (context, state) {
    if (state is ProductLoading) {
      return CircularProgressIndicator();
    } else if (state is ProductLoaded) {
      return ListView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
          );
        },
      );
    } else if (state is ProductError) {
      return Text('Error: ${state.error}');
    }
    return Container();
  },
);
```
## Key Points:

- Rebuilds based on state changes.
- Suitable for UI that directly depends on the state of the Bloc.
- Displays different UI components based on the state.

### 4. **MultiBlocProvider**
BlocListener listens to state changes and performs side effects (e.g., showing a snackbar, navigating to a new screen) in response. It does not rebuild its child widgets based on state changes.

#### Usage:
```dart

BlocListener<ProductBloc, ProductState>(
  listener: (context, state) {
    if (state is ProductError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
    }
  },
  child: YourWidget(),
);
```
## Key Points:

- Listens to state changes and performs side effects.
- Useful for showing notifications, snackbars, or navigating based on state.
- Does not rebuild its child widgets.

# Note : you can acheaive the same exact purpose of using BlocConsumer by nesting  BlocBuilder in a BlocListener

### 5. **MultiBlocListener**
MultiBlocListener allows you to listen to multiple Bloc or Cubit instances simultaneously. It is a collection of BlocListener widgets.

#### Usage:
```dart

MultiBlocListener(
  listeners: [
    BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product Error: ${state.error}')),
          );
        }
      },
    ),
    BlocListener<AnotherBloc, AnotherState>(
      listener: (context, state) {
        // Another listener logic
      },
    ),
  ],
  child: YourWidget(),
);
```
## Key Points:

- Listens to multiple Bloc or Cubit instances.
- Useful for managing side effects from multiple sources.
- Keeps the widget tree organized.

### 6. **BlocSelector**
BlocSelector rebuilds based on a specific part of the state of a Bloc or Cubit. It optimizes performance by selecting only the parts of the state that the widget cares about.

## Note : the BlocSelector only care about the sub state , he can triged change only for them. Even if the rest was changed he wouldn't be able to do display changes ( No rebuild ) . 

#### Usage:
```dart

BlocSelector<ProductBloc, ProductState, List<Product>>(
  selector: (state) {
    if (state is ProductLoaded) {
      return state.products;
    }
    return [];
  },
  builder: (context, products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price}'),
        );
      },
    );
  },
);
```
## Key Points:

- Rebuilds only when the selected part of the state changes.
- Optimizes performance by avoiding unnecessary rebuilds.
- Useful for widgets that only need a subset of the state.

# Important Comparison
### BlocBuilder vs BlocConsumer
#### BlocBuilder:

- Builds widgets based on the entire state of the Bloc.
- Rebuilds the widget whenever the state changes.
- Suitable for displaying different UI components based on the entire state.

#### BlocConsumer:

- Combines BlocBuilder and BlocListener.
- Allows you to rebuild the widget based on state and perform side effects.
- Provides both a builder function and a listener function.
- Useful for handling both state-based UI updates and side effects (e.g., showing a snackbar).

## Be curful : you need to use BlocConsumer if at once you need to listen and update widget only with a same state .If is not the case , make it a mixed nested between BlocListender that take as a child a BlocBuilder.

### BlocSelector vs BlocBuilder

#### BlocSelector:

- Rebuilds based on a specific part of the state.
- Optimizes performance by only rebuilding when the selected part of the state changes.
- Ideal for widgets that need only a subset of the state.

#### BlocBuilder:

- Rebuilds the widget based on the entire state.
- Can lead to unnecessary rebuilds if the widget only needs a part of the state.
- Suitable for general cases where the widget responds to all state changes.


## App & Documentation Features

- Examples of all major Bloc keys and features.
- Interactive UI to demonstrate state management using Bloc and Cubit.
- Clear and concise explanations of each provider.
- All in one.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yacine300/bloc_cubit_course.git
    cd bloc_cubit_course
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the app:
    ```bash
    flutter run
    ```

## Screenshots : 
<p align="center">
  <img src="https://github.com/Yacine300/bloc_cubit_course/blob/main/1.png" width="250" alt="Image 1">
  <img src="https://github.com/Yacine300/bloc_cubit_course/blob/main/2.png" width="250" alt="Image 2">
  <img src="https://github.com/Yacine300/bloc_cubit_course/blob/main/3.png" width="250" alt="Image 3">
</p>


# CS3217 Problem Set 4

**Name:** Stuart Long Chay Boon

**Matric No:** A0217528B

## Tips
1. CS3217's docs is at https://cs3217.github.io/cs3217-docs. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Dev Guide
## How to play

### Rules of the game

To win, you have to clear all orange pegs on the screen, before using up all 10 of your cannon balls, or before the timer runs out. 

Each blue peg and green pegs gives you 10 points, while the orange peg gives you 100 points. Your final score will be displayed at the bottom left corner, number of different pegs remaining at the bottom right, timer at the top left and number of cannon balls remaining at the top right of the screen. 

Each of the green peg has a super power. The green peg with the red shadow is the “Kaboom Peg”, which explodes when hit and destroys pegs around it. The green peg with the blue shadow is the “Spooky Peg”, which brings your peg back up to the top of the screen once your peg falls out.

The triangle blocks are just blocks to block you, and does not get destroyed.

You would be able to design and choose where to place the power ups/ pegs in the level designer.

Each cannon ball that falls in the bucket gives you one more cannon ball to use.

### Starting

Open the peggle clone app, and you will be welcomed by the home page of the app.

![Simulator Screen Shot - iPad Pro (11-inch) (3rd generation) - 2022-02-13 at 17 53 32](https://user-images.githubusercontent.com/77237808/155888818-08efe09d-fc4b-4903-a44a-76a5ffde0bba.png)

After which, you will be able to go to the level designer page by pressing the `Edit Levels` button, and the game by pressing the `Start` button.

To start designing a level, you can select any of the pegs/ triangle from the palette below, and place them anywhere on the screen. The power of the pegs are described in the rules of the game above. You would be able to move them around by dragging them. To delete any object, you can either press and hold on the object for 3 seconds, or press the delete button at the bottom right, and press the object you want to delete.

To resize the objects, you can press the resize button. When the button lights up, it means that it is selected, and you can resize the objects by dragging from the center. Note that there is a minimum and maximum size for the objects.

You can use the buttons at the bottom to save, load, reset or start playing the level.

![Simulator Screen Shot - iPad Air (4th generation) - 2022-02-27 at 22 45 40](https://user-images.githubusercontent.com/77237808/155888840-e648bc5e-d6b5-436b-9943-b90b8d0dd142.png)


To start playing, you can either press the `Start` button from the home page, or the level designer page. Pressing from the home page brings up a list of levels, and you can select the level you wish to play. Pressing from the level designer allows you to play that specific level that you were designing.

![Simulator Screen Shot - iPad Air (4th generation) - 2022-02-27 at 22 46 00](https://user-images.githubusercontent.com/77237808/155888852-7f067104-1f37-45c3-ba9c-8729a68a1ba9.png)

To aim the cannon, you would have to use your finger to drag the screen, and the cannon would follow. To shoot the cannon ball, you would have to tap the screen. Only one cannon ball is allowed in the play area each time, and you will be able to shoot another one once the cannon ball falls out of the screen. The number of cannon balls you have left is displayed on the top right of the screen.

And that’s it! Hope you have fun playing this peggle clone made by me.

## Architecture

This application is built using SwiftUI, following the MVVM model. The image below shows the overall architecture of my application.

![MVVMmodel](https://user-images.githubusercontent.com/77237808/155888859-10ceae11-c412-47f2-b7e3-39fc999d5c0c.png)

## Model:

My Model consists of a `PeggleObject`class, to capture all the objects in my game, a `Peg` class, modelling the Pegs displayed on the screen, `TriangleBlock` class modelling the triangle blocks, `Bucket` to represent the moving bucket, `Point` and `Vector` to represent `CGPoint` and `CGVector`, as well as a`Level` struct, which encapsulates the data of each level.

`Peg` stores important information such as location of the peg, type of peg (blue, orange or cannonBall) as well as the radius of the peg. `TriangleBlock` stores information such as the center of the triangle, the 3 vertices of the triangle, as well as its height and width, to calculate the area.

`Level` stores an array of `PeggleObject`s which represents the `PeggleObject`s displayed on the screen, as well as the name of the level.

## SLGameEngine

`SLGameEngine` is contains the domain logic of this game, and implements the Game loop, which is further explained below.

## SLPhysicsEngine

`SLPhysicsEngine` consists of `SLPhysicsWorld` , `SLPhysicsBody` , `SLPhysicsCollision`, `SLPhysicsTriangle`, `SLPhysicsBucket` and  `SLPhysicsCircle`. `SLPhysicsWorld` is the heart of `SLPhysicsEngine` , where it contains the logic behind this physics engine. `SLPhysicsBody` is a protocol, which is implemented by `SLPhysicsCircle` , `SLPhysicsTriangle` and `SLPhysicsBucket`, to give the different `PeggleObject`s physics properties. `SLPhysicsCollision` models the collisions between two `SLPhysicsBody`. It is further explained below.

## View Model:

My View Model consists of `LevelManager` , `AllLevelsManager`,  `StorageManager` , and `GameEngineManager` which are in charge of managing the `PeggleObject`s, `Level`s, loading and saving of data, as well as managing the `SLGameEngine` respectively.

`StorageManager` is in charge of loading and saving the data into a json file. It loads data from the json file at the start of the app inside `AllLevelsManager` , and saves to the same json file whenever the user presses the save button.

`AllLevelsManager` is in charge of managing all the `Level`s of the game in an array, and loading them into `LevelManager` to be displayed to the user. Upon initialisation, it retrieves the array of `Level` objects from storage through `StorageManager`. It then initialises `AllLevelsManager` with a `Level` object, to be displayed on the screen.  Whenever users select a level to load, `AllLevelsManager` loads the respective `Level` object of the level into `LevelManager`, which gets displayed to the user.

`LevelManager` is in charge of managing the `Level` and its `PeggleObject`s which are displayed on the screen. Whenever changes (moving, adding) are made to the `PeggleObject`s on the screen, it updates the `PeggleObject` contained in `LevelManager`'s `Level` object, which causes the changes to be rendered on the screen.

## View:

The View consists of `PeggleHomeView`, `LevelDesignerView` as well as `GameCanvasView`

When the user opens the application, he/she can expect to be greeted by the `PeggleHomeView`, shown below.

![https://user-images.githubusercontent.com/77237808/153756535-4a7ce532-730e-4ebe-861c-3cd757452e8e.png](https://user-images.githubusercontent.com/77237808/153756535-4a7ce532-730e-4ebe-861c-3cd757452e8e.png)

## Game Canvas View

The `GameCanvasView` consists of the `CannonView`, `LevelLoaderView`, `BucketView`, `PointsView`, `RemainingPegsView`, `CannonBallMagazineView` and the `TimerView`.

When the user clicks the `Start`button, the `LevelLoaderView` will pop up, for the user to select which level to play.
![Simulator Screen Shot - iPad Air (4th generation) - 2022-02-27 at 22 47 28](https://user-images.githubusercontent.com/77237808/155888936-9ddb47b7-5b40-4808-a4fd-84ae30e6b2ac.jpg)


Once the user selects a level to play, the `GameCanvasView` would be shown, with the `PeggleObject`s of the `Level` displayed on the screen. The image below shows how the individual views make up the entire `GameCanvasView`. Each `Peg` has its own `PegView` and each `TriangleBlock` has its own `TriangleView`.
![Simulator Screen Shot - iPad Air (4th generation) - 2022-02-27 at 22 47 44](https://user-images.githubusercontent.com/77237808/155888942-a896c644-3a32-431c-96b3-1a6125560dc9.jpg)


### LevelDesignerView

When the user selects the `Edit level` button, it will bring them to the `LevelDesignerView`, which consists of the `LevelDesignerCanvasView`, `ButtonsRowView`, `PegsRowView`, `LevelSelectorView` and the `NumberOfPegsView`. The image below shows how the different views make up the `LevelDesignerView`

![Simulator Screen Shot - iPad Air (4th generation) - 2022-02-27 at 22 47 54](https://user-images.githubusercontent.com/77237808/155888947-30611980-f969-4615-a7dd-0a9455535d70.jpg)
![Simulator Screen Shot - iPad Air (4th generation) - 2022-02-27 at 22 48 00](https://user-images.githubusercontent.com/77237808/155888948-10244e13-a279-437a-9ee2-6b9808eefff7.jpg)


## Key Flows

**Start Up**

![CS3217Startup](https://user-images.githubusercontent.com/77237808/155888959-bdaaca2e-bc5a-486e-b112-62270bffdea9.png)

When the user starts the app, the `AllLevelsManager` gets initialised and subsequently retrieves the array of `Level` objects from storage through `StorageManager#loadLevels`, then initialises`LevelManager` with a `Level` object, to be displayed on the screen. Since `Level` is a struct, `LevelManager` actually stores a copy of the `Level` object from `AllLevelsManager`. However, since `PeggleObject` is a class, any changes to the `PegleObject`s in the copy of `Level` object in `LevelManager` would cause a change to the `PeggleObject`s in the `AllLevelsManager` , which is undesirable because the user’s changes would be saved even without pressing the `Save` button. Thus it gets a copy of the `PeggleObject`s and assign the copy to the `Level` struct when we initialise the `LevelManager`.

### Level Designer

**Adding and Dragging of PeggleObjects**

![CS3217AddPegs](https://user-images.githubusercontent.com/77237808/155888963-e848300a-0154-48ab-a069-87c95dd16196.png)

When the user clicks on a location on the `Background` to add the `PeggleObjects` s, the View calls `LevelManager#addSelected` which checks if it is safe to place the selected `PeggleObject` at the location, by calling `LevelManager#safeToPlaceObjectAt`, and if so, calls `Level#addPeggleObject`, which adds it to the array of `PeggleObject`s in the `Level` object. This causes the UI to update the view to display it on the screen because `Level` is a `@Published` property in `LevelManager`. Since `Level` is a struct, the `Level` object in the `AllLevelsManager` does not get updated, which is what we want. (We only update it when the user clicks save)

`LevelManager#safeToPlaceObjectAt` checks if the location we want to add the peggle object to overlaps with any other peggle object on the screen, and whether it exceeds the edges of the screen.

Similar steps are followed for the dragging of peggle objects, and will only be moved if it is safe to place the `PeggleObject` at the location.

**Deletion of PeggleObjects**

For the deletion of `PeggleObject`s, the View calls `LevelManager#delete(peggleObject)`  to delete the peggle object from the `Level` object in `LevelManager`. As mentioned in the “Adding and dragging peggle objects” section, since `Level` is a struct, deleting would only delete the copy of the `PeggleObject`s from `LevelManager`, which does not reflect on the array of `PeggleObject`s in `Level` until the user saves his changes.

**Saving Levels**

![CS3217SavingLevel](https://user-images.githubusercontent.com/77237808/155888969-7df8ac12-7378-4103-8a3d-6bf1f18c7c3e.png)

When the save button is pressed, the View calls `LevelManager#save` which updates the `Level` object in the `AllLevelsManager` with the details of the `Level` object in `LevelManager`, and changes the name of the level if there are changes. After writing the changes to `AllLevelsManager`, the changes made by the user on the level would be permanent. After updating `AllLevelsManager`'s `Level` object, `AllLevelsManager` calls its `saveLevels` method, to save the changes made to the level into the json file. This ensures that the json file is always updated, and that data would not get lost if the app crashes.

**Changing Levels**

![CS3217ChangingLevels](https://user-images.githubusercontent.com/77237808/155888977-90ad06ce-a995-4f29-98e6-0f8c36179221.png)

When a level is selected by the user to load, the View calls `LevelManager#changeLevel` , which assigns the level to change to to the `LevelManager`. It then makes a copy of the `PeggleObject`s into the `Level` object of `LevelManager`, so that the original array of `PeggleObject`s would be preserved in case the user decides not to save his/her changes.

## SLGameEngine (Game Loop)

`SLGameEngine` follows the implementation of the game loop from [here](http://gameprogrammingpatterns.com/game-loop.html#one-small-step,-one-giant-step). The steps of the game loop can be found below.

`SLGameEngine` gets initialised when the user selects the `Level` which he/she wants to play after clicking `Start` from the home page. Once it is selected, the view calls `GameEngineManager#loadLevels`, which loads the `PeggleObject`s from the selected level into `SLGameEngine`, which converts them into `SLPhysicsBody` objects, and loads them into `SLPhysicsWorld`. `SLPhysicsBody` gives these `PeggleObject`s attributes to help simulate their movements in the game. It also loads a `Peg`  of type `cannonBall`, to be placed in the cannon before being fired by the user. Additionally, `SLGameEngine` stores a dictionary containing the mappings of each `PeggleObject` to their respective `SLPhysicsBody` , so that their positions in the UI can get updated during the render stage.

![https://user-images.githubusercontent.com/77237808/153756822-cb3f42c4-0b1a-4621-ad2c-5175d4eeeef4.png](https://user-images.githubusercontent.com/77237808/153756822-cb3f42c4-0b1a-4621-ad2c-5175d4eeeef4.png)

After loading the levels, `GameEngineManager#start` gets called, to start the game loop. Once the user selects a direction to fire the cannon ball, the cannon ball would start moving and colliding with the `PeggleObject`s, lighting them up (except the `TriangleBlock`s) as they are hit.

![https://user-images.githubusercontent.com/77237808/153756827-0e5603b5-1688-4212-b78a-e62e7ad2c058.png](https://user-images.githubusercontent.com/77237808/153756827-0e5603b5-1688-4212-b78a-e62e7ad2c058.png)

![https://user-images.githubusercontent.com/77237808/153756836-947011a9-aecb-42b2-9f55-2301cf6f52d6.png](https://user-images.githubusercontent.com/77237808/153756836-947011a9-aecb-42b2-9f55-2301cf6f52d6.png)

The game engine has a `PowerUpHandler`, which abstracts out the implementation details of the power ups, and executes these power ups when they are activated.

The `SLGameEngine` stores weak references to 2 delegates, the `GameLogicDelegate`, implemented by the `GameEngineManager`, to manage the logic of the game which is displayed to the user, for eg if the game is won, lost, timer up, number of points, and number of cannon ball ammo left. It also stores reference to the `GameDisplayDelegate`, implemented by `LevelManager`, which updates the display of the pegs and objects on the screen.

This is to encapsulate and abstract out relevant information from the `SLGameEngine`, as it is a model, and should not know about the View Models directly.

## Physics Engine

The main logic behind the Physics Engine can be found in `SLPhysicsWorld`. Steps of the simulation would be explained in this section.

![https://user-images.githubusercontent.com/77237808/153756848-44ff370c-fb0a-4736-953b-fdd269c1a14c.png](https://user-images.githubusercontent.com/77237808/153756848-44ff370c-fb0a-4736-953b-fdd269c1a14c.png)

When `SLPhysicsWorld#simulatePhysics()` is called, it would first generate the new positions of the `SLPhysicsBody` after one tick. After which, `SLPhysicsWorld#getCollisions()` would be called, to create `SLPhysicsCollision` objects to encapsulate the details of the collision. Next, it would resolve the collisions, by calculating the resultant velocity of the `SLPhysicsBody`. Then, it would resolve any collisions with the edges of the screen, by translating the ball backwards, and changing the velocity of the `SLPhysicsBody`. Following which, it would resolve any overlaps between the `PeggleObject`s, by translating them back in the direction they came from. Lastly, it would all `SLPhysicsWorld#updateVelocityOfNodes()` to update the velocity of the ball, to its resultant velocity. This is all done within one frame in the game loop.

### Persistance

For the persistance method, I used JSON. As shown in my overall architecture diagram, most of my models have a respective persistance model. For eg, `Level` has a `LevelPersistance`, `Peg` has a `PegPersistance` and so on. These persistance models are used to reduce coupling by abstracting away the persistance details from my models, and only store what is necessary. One important thing which my persistance models does is to handle the letter boxing. It is described in the steps below.

1. During saving of data, the app saves the width and height of the canvas into the json file.
2. During the start up of the game, the persistance models take in the new canvas width and height, and uses its stored canvas width and height, as well as the various parameters of the shapes, and scales the object’s center, width, height, radius etc, such that it follows the same ratio, for all different devices.

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction

### Win and Lose Conditions
The player wins the game by clearing all orange pegs before the timer runs out or the run out of cannon ball ammo.

## Level Designer Additional Features

### Peg Rotation
Please explain how the player rotates the triangular pegs.

### Peg Resizing
The player can resize the peg by pressing the resize button, and then dragging the pegs away from its center to increase its size, and towards its center to decrease its size

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.
### Background music

Background music has been added to the game, and plays throughout the duration of the game. Credits to  [https://www.bensound.com/](https://www.bensound.com/) for the free music clips.

### Score system

A score system was implemented in the game. `PeggleObject`s with points stored their points in their model, and whenever they are removed from the game canvas, their points would be added to the total score. Each orange peg gives 100 points, and each non orange pegs give 10 points.

### Displaying number of pegs left in game

During the game, it displays the number of special pegs (spooky peg and kaboom peg), blue pegs and orange pegs left.

### Displaying number of pegs added in the level designer

In the level designer, it displays how many special pegs (spooky peg and kaboom peg), blue pegs, orange pegs and triangle blocks have been added in the level already.

### Timer

The timer is displayed in the game, and gives the user 100s to finish the level. If 100s is up and there are still orange pegs in the game, the user loses.

### Visual Representation of the ammo left

A visual representation of the number of cannon balls the user has left is displayed in the game screen, so that the user will know how many cannon balls he/she has left to clear the game.


## Tests
## Unit Test

- `Peg.swift`
    - `init(type: PegType, center: CGPoint, radius: Double = 35)` method
        - When passed with PegType.orangePeg, it should initialise property type to PegType.orangePeg.
        - When passed with PegType.bluePeg, it should initialise property type to PegType.bluePeg.
        - When passed with a CGPoint for center, it should initialise the property center to the value.
        - When passed with a double for radius, it should initialise the property radius to the value.
        - When passed with no value for radius, it should initialise the property radius to 35
    - `shiftTo(location: CGPoint)` method
        - When passed with a CGPoint for location, it should change the property center to the given value for location.
    - `overlap(peg: Peg)` method
        - When passed with a Peg, it should return whether both pegs overlap based on their radius.
    - `==(lhs: Peg, rhs: Peg)` method
        - When passed with two Pegs with the same id, type, center and radius, it should return true.
        - When passed with two Pegs with a different id, type, center or radius, it should return false.
    - `glow()`
        - If it is the PegType of the object is PegType.pegBlue, it should change to PegType.blueGlow
        - If it is the PegType of the object is PegType.pegOrange, it should change to PegType.orangeGlow
- `Level.swift`
    - `init(name: String, pegs: [PegObject])` method
        - When passed in a String for name, it should initialise the property name to the value.
        - When passed in a [PegObject] for pegs, it should initialise the property pegs to the value.
    - `save(name: String, pegs: [PegObject])`
        - When passed in a String for name, it should change the property name to the value.
        - When passed in a [PegObject] for pegs, it should change the property pegs to the value.
    - `== (lhs: Level, rhs: Level)` method
        - When passed in two Level objects with the same id, name and pegs, it should return true.
        - When passed in two Level objects with different id, name or pegs, it should return false.
- `PegManager.swift`
    - `init(level: Level)` method
        - When passed in a Level for level, it should initialise the property level to the value, and initialise the property pegs to a copy of the pegs property of value. They should not be the same.
    - `delete(peg: PegObject)` method
        - When passed in a PegObject which exists in the property `pegs`, it should remove the PegObject from `pegs` , but not from the property `pegs` of the property `level`.
        - When passed in a PegObject which does not exist in the property `pegs`, it should not remove any PegObject from `pegs` and from the property `pegs` of the property `level`.
    - `delete(pegLocation: CGPoint)` method
        - When passed in a CGPoint which coincides with the `center` of a PegObject in `pegs`, it should remove the PegObject from `pegs` , but not from the property `pegs` of the property `level`.
        - When passed in a CGPoint which does not coincide with the `center` of any PegObject in `pegs`, it should not remove any PegObject from `pegs`and from the property `pegs` of the property `level`.
    - `deleteAll()` method
        - It should delete all the PegObject in the property `pegs`, but not from the property `pegs` of the property `level`.
    - `select(peg: Peg.PegType)` method
        - When passed in a Peg.PegType, it should set the property `selectedPeg` to that value and the property `isDeleteSelected` to `false`
    - `selectDelete()` method
        - It should set the property `isDeleteSelected` to true and the property `selectedPeg` to `nil`
    - `addPeg(center: CGPoint, canvasDimensions: CGRect)` method
        - When passed in a CGPoint and CGRect, it should add a PegObject with type `selectedPeg` , center with the value of type CGPoint, and the default radius size, only if it does not overlap any other PegObject in the property `pegs` and does not exceed out of the canvas with the value of type CGRect.
        - When passed in a CGPoint and CGRect, it should not add a PegObject with type `selectedPeg` , center with the value of type CGPoint, and the default radius size, if it overlaps with some other PegObject in the property `pegs` but does not exceed out of the canvas with the value of type CGRect.
        - When passed in a CGPoint and CGRect, it should not add a PegObject with type `selectedPeg` , center with the value of type CGPoint, and the default radius size, if it does not overlap with any other PegObject in the property `pegs` but exceeds out of the canvas with the value of type CGRect.
        - When passed in a CGPoint and CGRect, it should not add a PegObject with type `selectedPeg` , center with the value of type CGPoint, and the default radius size, if it overlaps with some other PegObject in the property `pegs` and exceeds out of the canvas with the value of type CGRect.
    - `safeToPlacePegAt(center: CGPoint, canvasDimensions: CGRect)` method
        - When passed in a CGPoint and CGRect, it should return true if the PegObject of with any `selectedPeg` type, center at the value of type CGPoint, and the default radius size does not overlap any other PegObject in the property `pegs` and does not exceed out of the canvas with the value of type CGRect.
        - When passed in a CGPoint and CGRect, it should return false if the PegObject of with any `selectedPeg` type, center at the value of type CGPoint, and the default radius size overlaps with some other PegObject in the property `pegs` but does not exceed out of the canvas with the value of type CGRect.
        - When passed in a CGPoint and CGRect, it should return false if the PegObject of with any `selectedPeg` type, center at the value of type CGPoint, and the default radius size does not overlap any other PegObject in the property `pegs` but exceeds out of the canvas with the value of type CGRect.
        - When passed in a CGPoint and CGRect, it should return false if the PegObject of with any `selectedPeg` type, center at the value of type CGPoint, and the default radius size overlaps with some other PegObject in the property `pegs` and also exceeds out of the canvas with the value of type CGRect.
    - `move(pegLocation: CGPoint, newLocation: CGPoint)` method
        - When given a value for `pegLocation` and a value for `newLocation`, if there exists a PegObject in `pegs` with property center as `pegLocation`, it should set the property center as the value of `newLocation`.
        - When given a value for `pegLocation` and a value for `newLocation`, if there does not exist a PegObject in `pegs` with property center as `pegLocation`, it should not set any PegObject in `pegs`'s property center as the value of `newLocation`.
    - `save(name: String)` method
        - When given a String for `name` that is not an empty String after trimming all whitespace (””), it should set `PegManager`'s `level` property’s `pegs` property to `PegManager` ’s `pegs` property, and change `PegManager`'s `level` property’s `name` property to the String value of `name`.
        - When given a String for `name` that is an empty String after trimming all whitespace (””), it should set `PegManager`'s `level` property’s `pegs` property to `PegManager` ’s `pegs` property, but not change `PegManager`'s `level` property’s `name` property.
        - When given a String for `name` with whitespace at the front and not “” after its trimmed, it should set`PegManager`'s `level` property’s `pegs` property to `PegManager` ’s `pegs` property, and change `PegManager`'s `level` property’s `name` property to the trimmed `name`.
        - When given a String for `name` with whitespace at the back and not “” after its trimmed, it should set`PegManager`'s `level` property’s `pegs` property to `PegManager` ’s `pegs` property, and change `PegManager`'s `level` property’s `name` property to the trimmed `name`.
    - `changeLevel(level: Level)` method
        - When given a Level for `level`, it should set `PegManager` ’s `level` property to the value of the input `level`, and replace `PegManager` ’s `pegs` property with a copy of the input `level`'s `pegs` property.
    - `unselectPeg()` method
        - When called, `PegManager`'s `selectedPeg` should be assigned to nil
    - `unselectDelete()` method
        - When called, `isDeleteSelected` should be assigned to false
- `LevelManager.swift`
    - `init()` method
        - It should initialise the `levels` property of `LevelManager` to the value read from the json file “Source.json” at the `sourceURL` of `StorageManager` , if the path to the json file exists.
        - It should initialise the `levels` property of `LevelManager` to the value read from the json file “Seed.json” at the `seedURL` of `StorageManager` , if the json file at the path `sourceURL` of `StorageManager` does not exist.
    - `saveToFile()` method
        - It should save the encoded property `levels` and save into the json file “Source.json” at the `sourceURL` of `StorageManager`.
    - `createNewLevel()` method
        - It should create a new Level Object, with name “New Level \(levels.count + 1)” and an empty array of pegs, and append it to the `levels` property of `LevelManager`. It should return the new Level Object created.
    - `initialisePegManager()` method
        - It should return a PegManager with the first level of the `levels` property, if there exists at least 1 Level Object in `levels`.
        - It should return a PegManager with a new Level of name “New Level 1” and an empty array of pegs, and append it to the `levels` property of `LevelManager`.
- `StorageManager.swift`
    - `loadLevels()` method
        - It should decode the json file “Source.json” with utf8 encoding at path `sourceURL`if it exists, and return the decoded Level array.
        - It should decode the json file “Seed.json” with utf8 encoding at path `seedURL` if the file “Source.json” at parth `sourceURL` does not exist, and return the decoded Level array.
    - `saveLevels(levels: [Level])` method
        - It should encode the value of `levels` with utf8 encoding and save it at the json file “Source.json” at path `sourceURL`.
- `GameEngineManager.swift`
    - `loadLevel(pegManager: PegManager)` method
        - It should call the `loadLevel()` method of the `SLGameEngine` and pass in the `PegManager`
    - `start()` method
        - It should cause the game loop to start
    - `fireCannonBall()` method
        - It should call the `fireCannonBall` method of `SLGameEngine`
- `SLGameEngine.swift`
    - `loadLevel(pegManager: PegManager)`
        - It should assign the pegManager to the `SLGameEngine` object
        - It should convert the `Peg`s from the `Level` object in `pegManager` into `SLPhysicsCircle`
        - It should load the converted `Peg`s into the `SLPhysicsEngine`
        - It should add the cannon ball to the `SLPhysicEngine`
        - It should create a dictionary of `Peg` to its respective `SLPhysicsCircle` object and assign it to the mappings attribute in the `SLGameEngine` class.
    - `addCannonBall()`
        - It should create a `Peg` object with centre at `CGPoint(x: 400, y: 50)`to represent the cannon ball, and assign it to the `cannonBall` attribute in `SLGameEngine`.
        - It should not create a `SLPhysicsCircle` object to represent the cannonBall, and add the key value pair of `cannonBall` to its respective `SLPhysicsCircle` object into the mappings attribute.
        - It should add the cannon ball to the `SLPhysicsEngine`
        - It should update the `mostRecentPosition` attribute of `SLGameEngine` to the centre of the cannonBall.
    - `isCannonBallSamePosition()`
        - Returns true if the cannonBall is within +/- 10 pixels away from its previous x and y coordinates.
    - `contains(arr: [SLPhysicsBody], physicsBody: SLPhysicsBody)`
        - When given an `arr` which has a `SLPhysicsBody` with the same centre as the `physicsBody` input, it should return true
        - When given an `arr` which does not have a `SLPhysicsBody` with the same centre as the `physicsBody` input, it should return false.
        - When given an empty `arr`, it should return false.
    - `fireCannonBall(directionOf: CGPoint)`
        - When given a direction below the cannonBall, it should create a `SLPhysicsCircle` to represent the cannonBall, with velocity from the centre of the cannonBall to `directionOf` and add it to the mappings attribute.
        - When given a direction above the cannonBall, it should create a `SLPhysicsCircle` to represent the cannonBall, with velocity from the centre of the cannonBall to `directionOf`, with `dy` of at most the `x`value of the cannonBall’s position, and add it to the mappings attribute.
- `SLPhysicsWorld.swift`
    - `load(physicsBodies: [SLPhysicsBody], canvasDimensions: CGRect)`
        - It should assign `self.physicsBodies` to `physicsBodies` and `self.canvasDimensions` to `canvasDimensions`
    - `simulatePhysics(duration: TimeInterval)`
        - It should simulate the `physicsBodies` for a duration of `duration`, calculating their new positions, resolving collisions, as well as generating their new velocity after the specified duration.
    - `generateNewPositions(duration: TimeInterval)`
        - It should generate the new positions of the `physicsBodies` , if they are dynamic objects.
        - It should remove physicsBodies if they are out of the screen, so that it does not have to manage so many `SLPhysicsBody`
    - `generateNewPosition(physicsBody: SLPhysicsBody, duration: TimeInterval)`
        - It should generate new position of `physicsBody`, after a duration of `duration` , following the physics formula `s = ut + 1/2(a*t*t)`. It should also update the `SLPhysicsBody` from gravity after that duration.
    - `isOutOfScreen(physicsBody: SLPhysicsBody)`
        - Returns true if `SLPhysicsBody` is out of the screen by more than 2 * the height of the screen.
        - Returns false if `SLPhysicsBody` is not out of the screen.
        - Returns false if `SLPhysicsBody` is out of the screen but not by more than 2 * the height of the screen.
    - `getCollision()`
        - Creates `SLPhysicsCollision` objects if there are any overlapping `SLPhysicsBody` in the `physicsBodies` attribute, sets their `isCollided` attribute to true, and adds each other to their `collisionsWith` array in the `SLPhysicsBody` to track who they collided with this tick.
    - `resolveCollision`
        - It should call `SLPhysicsCollision#resolve` for all `SLPhysicsCollision` in the `collisions` array.
    - `resolveEdgeCollision()`
        - It should resolve all the `SLPhysicsBody` if they are colliding with the edges of the screen, and shift them back into the screen.
        - It should set the velocity of the `SLPhysicsBody` to make the ball move in the opposite direction after collision with the edges.
    - `updateVelocityOfNodes()`
        - It should call the `SLPhysicsBody#resolveForces` method to resolve the forces on each `SLPhysicsBody`, and calculate its new velocity
    - `resolveOverlaps()`
        - It should resolve any overlaps between `SLPhysicsBody` in the `physicsBodies` array in the class, and move the dynamic objects backwards so it does not have any overlap.
    - `getCircleIntersectAmount(_ firstBody: SLPhysicsBody, _ secondBody: SLPhysicsBody)`
        - When 2 circles are overlapping, it should return a positive amount.
        - When 2 circles are just touching, it should return 0.
        - When 2 circles are not intersecting, it should return a negative amount.
    - `addCannonBall(cannonBall: SLPhysicsCircle)`
        - It should append the cannonBall into the `physicsBodies`
- `SLPhysicsCircle.swift`
    - `moveTo(position: CGPoint)`
        - It should set the position of the `SLPhysicsCircle` to the given position
    - `setVelocity(newVelocity: CGVector)`
        - It should set the velocity of the `SLPhysicsCircle` to the given velocity.
    - `intersectWithCircle(circleBody: SLPhysicsBody)`
        - When given a `SLPhysicsCircle` , it should return true if the circle intersects with the given `circleBody`
        - When not given a `SLPhysicsCircle`, it should return a fatal error
    - `isColliding(collidingCircle: SLPhysicsCircle)`
        - If the circle is overlapping with the object, it should return true
        - If the circle is not overlapping with the object, it should return false.
    - `resolveForces`
        - It should calculate the resultant force of all the forces acting on this `SLPhysicsCircle`, and set its velocity to the resultant velocity.
    - `setNotDynamic()`
        - It should set the `isDynamic` attribute to false.
    - `setCollided()`
        - It should set the `hasCollided` attribute to true.
    - `ignore()`
        - It should set the `canIgnore` attribute to true.
    - `moveBackBy(distance: Double)`
        - Itt should move the object back by the given distance, in the opposite direction of its velocity.
    - `setDynamic()`
        - It should set the `isDynamic` attribute to true.
    - `addCollisionWith(physicsBody: SLPhysicsBody)`
        - It should add the `physicsBody` to its `collisionsWith` array.
    - `clearCollisionsWith()`
        - It should remove all elements from the `collisionsWith` array.
    - `unignore()`
        - It should set the `canIgnore` attribute to false.
- TriangleBlock
    - overlap
        - Should return true given a peggle object within the triangle
        - should return false given a peggle object outside the triangle
        - should return true given a peggle object on the edges of the triangle
        - should return true given a peggle object on the vertices of the triangle
    - shiftTo
        - should shift the triangle to the new position, and calculate the new position of all 3 of its vertices
    - ResizeObject
        - If new size is within the acceptable range, should resize the triangle
        - If new size exceeds the acceptable range, should set the size to the upper bound
        - If new size is below the acceptable range, should set the size to the lower bound

## Integration Testing

### Home Screen

- Pressing of `Start` button
    - When the `Start` Button is clicked, it should bring you to the page to choose levels to play.
- Choosing level to play
    - After selecting level to play, the level displayed on the screen should match the level selected.
    - When choosing level to play, touching the dark areas outside the pop up box should not close the pop up box.
- Pressing of `Edit Levels` Button
    - When the `Edit Levels` button is clicked, it should bring you to the page to choose levels to edit levels.
- Choosing level to edit
    - After selecting level to edit, the level displayed on the screen should match the level selected.
    - When choosing level to edit, touching the dark areas outside the pop up box should close the pop up box, and show the first level in the list.

### Game play

- Shooting of cannon ball
    - Ball should fire in the direction which the cannon is facing
    - Cannot ball should not fire in a direction that is not in the direction of the cannon
- Collision with pegs
    - When cannon ball collides with the pegs, it should bounce of in a reasonable manner. It will however, lose some of its energy, like normal objects upon collision.
    - When cannon ball collides with spooky peg, it should have a blue shadow around it
    - When cannon ball hits a kaboom peg which activates a spooky peg, the cannon ball should have a blue shadow around it
    - When cannon ball hits a kaboom peg, it should get thrown off its original trajectory
- Collision with Triangles
    - When cannon ball collides with the Triangles, it should bounce off in a reasonable manner
    - Triangle blocks should not get lit up when hit
- Collision with edges
    - When cannon bal collides with the left edge of the screen, it should bounce to the right in a reasonable manner, but with less speed.
    - When cannon bal collides with the right edge of the screen, it should bounce to the left in a reasonable manner, but with less speed.
    - The cannon bal should not collide with the top of the screen.
    - The cannon ball should not collide with the bottom of the screen.
- Removal of pegs
    - When the cannon ball exits the screen, all lighted up pegs should be removed from the screen
    - When the cannon ball exits the screen, all non lighted up pegs should not be removed from the screen.
- Removal of triangle blocks
    - Triangle blocks should not be removed when cannon ball exits the screen, as it is a block not a peg.
- Removal of pegs when stuck
    - When pegs are blocking the cannon ball from falling down, it should be removed to allow the ball from moving down. The other lighted pegs should not be removed.
- Removal of triangles when stuck
    - When triangle blocks are blocking the ball from fallling, it should be removed to allow the ball to fall, and added back after the ball passes through it since it is a blokc
- Reloading of cannon balls
    - After the cannon ball drops out of the screen, a new cannon ball should be reloaded and displayed at the top centre of the screen.
    - If the cannon ball is still bouncing within the screen, no cannon ball should be reloaded and displayed at the top centre of the screen.
- Turning of the cannon
    - Cannon should follow the user’s finger when user drags the screen
    - Cannon should not point anywhere else other than in the direction of the user’s finger

### Level Designer

- Add pegs
    - When blue peg is selected, tapping on the screen should place a blue peg if it does not overlap with any other pegs.
    - When orange peg is selected, tapping on the screen should place an orange peg if it does not overlap with any other pegs.
    - When no pegs are selected, tapping anywhere on the screen should not add any peg.
- Delete pegs (delete button)
    - When the delete button is selected tapping a peg which is on the screen should delete the peg.
    - When delete button is selected, tapping a location of the screen without a peg should not delete any pegs.
- Delete pegs (press and hold)
    - When holding down on a peg, it should delete the peg after 1.5s.
    - When holding down on an empty spot, it should not delete any peg.
- Move pegs
    - When dragging a peg, the peg should follow your finger to anywhere it drags, as long as it does not overlap with any other peg or goes out of the screen.
    - When dragging over another peg, the peg should animate and fly under the peg. It should not be stuck underneath/over that peg.
- Load levels
    - When the load button is pressed, a list of past levels created should be displayed.
    - When the load button is pressed, a list of past levels created should be displayed, and pressing any level should display the layout of the pegs of that level.
    - When the load button is pressed, a list of past levels created should be displayed, and pressing any level should not display the layout of the pegs of another level.
- Reset
    - When the reset button is pressed, all the pegs displayed on the screen should be removed.
    - When the reset button is pressed, none of the pegs displayed on the screen should not be removed.
- Save
    - When the save button is pressed, the peg layout should be saved, and when the level is loaded again, it should reflect the new layout.
    - When the save button is pressed, the peg layout should be saved, and when the new level is loaded again, it should not reflect the old layout.
    - When the save button is not pressed, the peg layout should not be saved, and when the same level is loaded back, it should not reflect any changes, and should display the old layout.
- Portrait
    - The app should not be able to turn to landscape mode, and should only work in portrait mode.
- Keyboard
    - When the keyboard is up, the entire screen should be translated upwards, and none of them should be covered by the keyboard.
    - When the keyboard is up, we should not be able to delete pegs from the screen.
    - When the keyboard is up, we should not be able to move pegs on the screen.
    - When the keyboard is up, we should be able to load levels.
    - When the keyboard is up, we should be able to save levels.
    - When the keyboard is up, we should be bale to reset levels.
- Reloading the app
    - When the app is reloaded, the data should be saved and the peg layout should be the same as the last saved layout.
- PegsRow (to select the pegs to place on the board and delete button).
    - When an unselected peg is pressed, all other buttons should be unselected and it should be selected (lighted up).
    - When a selected peg is pressed again, it should be unselected.
    - When the delete peg button is selected, all other buttons should be unselected and it should be selected (lighted up).
- New level
    - When a new level is pressed, it should load a new level with no pegs on the screen and the name should be “New Level \(number of levels)”
- Saving of level names
    - When a level’s name is unchanged and saved, the name should be unchanged.
    - When a level’s name is changed and saved, the name should be changed only if the new name is not empty, or consists of only whitespaces.
    - When a level’s name is changed and saved, if the name has whitespace at the front or the back and is not all whitespace, it should be trimmed and that should be the new level name.
    - When saving a level with the same name as an old name, it should add an extra number at the back, to indicate it is a different level. Eg “same name (1)”
- Resizing of PeggleObjects
    - Resizing of PeggleObjects next to another peggle object should not cause overlap between the two.
    - Resizing of peggle objects at the edges of the screen should not cause the peggle object to exceed the boundaries.
    - Resizing should happen when the resize button is pressed
    - Resizing should not happen when the resize button is not pressed
- Start button
    - pressing of start button should start the peggle game with that level which was shown in the level designer
    - when start button is pressed from level designer, user does not have to select levels from the level loader

## Others

- exit button
    - When exit button is pressed from level designer OR start game, it should bring the user back to the home page.
- Background music
    - Should be played throughout the entire app

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

I feel that I did not design my code in the previous problem sets well enough. There were lots of coupling, and it was not very extensible. One example was, instead of creating PeggleObjects, i only created a Pegs class, which could only represent Pegs. When i had to represent Triangles, it was pretty hard.

Yes there were technical debt i had to clean up, mainly was to refactor and reconstruct my classes, like the PeggleObject class mentioned. Also, there was coupling between my model and persistance, and i had to refactor them and decouple it so that it would be easier for me to save more information in JSON format.

If i were to redo the entire application, I would want to first read all the problem sets, so i know roughly what i have to do for the application. Then i would be able to plan my code well, and the structure of my code. I would have liked to use more patterns taught in CS3217, like the delegate, decorator, publisher subscriber pattern, had i known about them earlier. I am sure that if i were to incorporate these patterns, it would be able to solve more problems for me.

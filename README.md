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
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

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

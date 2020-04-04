# Wings

_Navigation_

1. [Startup](startup.md)
2. [Airfoils](airfoils.md)
3. [Wings](wings.md)
4. [Plane](plane.md)
5. [Matlab](matlab.md)

## Wing and Plane Design

Following the preliminary steps given within the [previous section](airfoils.md), concerning the airfoil design - along with the instructions to run an analysis - in the `File > XFoil Direct Analysis` environment, it is now possible to design a plane (or at least a wing system) starting from the main wing design.

![alt text](screenshots/wing_01.png)

Once inside the `File > Wing and Plane Design` go directly to the `Plane Editor` window clicking on the dropdown menu `Plane > Design a New Plane`, first to design - at least at this stage - just the `Main wing`.

![alt text](screenshots/wing_02.png)

Remeber to uncheck everything, but the (default) `Main wing` box. We will see in the [next section](plane.md) how to setup a more complex wing system, made of an `Elevator`, `Fin`, eventually a `Body` and moreover how the `Biplane` feature reveals to be an effective expedient to account for the [*ground effect*](https://en.wikipedia.org/wiki/Ground_effect_(aerodynamics)), mimicking in a trivial way the so called [*method of images*](https://en.wikipedia.org/wiki/Method_of_image_charges).

![alt text](screenshots/wing_03.png)

In the `Wing Edition` window, you will be allowed *tailoring* your wing setting up any geometrical parameter (the wingspan `y`, the `chord`, `offset`, `dihedral` angle, `twist` angle, the section `foil`) defining as many `sections` as you want to make these parameters changing too.

![alt text](screenshots/wing_04.png)

To start it is also possible to leave everything unchanged, but in this case do not forget to chose at least one `foil` - among the ones made available in the [previous section](airfoils.md) - for both `sections` (the wing root/tip).

![alt text](screenshots/wing_05.png)

Once a particular `foil` has been chosen for each section - checking the `Surfaces` box on the right column - the nonzero thickness three-dimensional wing will be highlighted. Just click on the `Save` button in the lower right corner.

![alt text](screenshots/wing_06.png)

After the `Main wing` has been saved - back in the `Plane Editor` window - you can change the `Plane Description` name just before saving it, again clicking on the `Save` button in the lower right corner here above.

![alt text](screenshots/wing_07.png)

Just in case no wing is appearing on of your screen: click on the `View > 3D View` dropdown menu, as shown here above.

![alt text](screenshots/wing_08.png)

To set up your analysis click on `Analysis > Define an Analysis` to open the `Analysis Definition` window here below.

![alt text](screenshots/wing_09.png)
![alt text](screenshots/wing_10.png)
![alt text](screenshots/wing_11.png)
![alt text](screenshots/wing_12.png)
![alt text](screenshots/wing_13.png)
![alt text](screenshots/wing_14.png)
![alt text](screenshots/wing_15.png)

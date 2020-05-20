# Plane

_Navigation_

1. [Startup](startup.md)
* [Welcome to xflr5](startup.md/#Welcome-to-xflr5)
* [Running xflr5](startup.md/#Running-xflr5)
* [Direct Foil Design](startup.md/#Direct-Foil-Design)
2. [Airfoils](airfoils.md)
* [XFoil Direct Analysis](airfoils.md/#XFoil-Direct-Analysis)
* [Naca Foils](airfoils.md/#Naca-Foils)
* [Define an Analysis](airfoils.md/#Define-an-Analysis)
* [Export data](airfoils.md/#Export-data)
3. [Wings](wings.md)
* [Wing and Plane Design](wings.md/#Wing-and-Plane-Design)
* [Define an Analysis](wings.md/#Define-an-Analysis)
* [Export data](wings.md/#Export-data)
4. [Plane](plane.md)
* [Wing and Plane Design](plane.md/#Wing-and-Plane-Design)
* [Examples](plane.md/#Examples)
  * [Spitfire elliptical wing](plane.md/#Spitfire-elliptical-wing)
  * [F1 rear wing](plane.md/#F1-rear-wing)
  * [X-wing starfighters](plane.md/#X-wing-starfighters)
  * [NACA 4415 on Boeing 737 & Cessna 172 wings](plane.md/#NACA-4415-on-Boeing-737-&-Cessna-172-wings)
5. [Matlab](matlab.md)
* [Matlab post processing](matlab.md/#Matlab-post-processing)

## Wing and Plane Design

Following the preliminary steps given within the [previous section](wing.md), to design a wing - along with the instructions to run an analysis - in the `File > Wing and Plane Design` environment, it is now possible to design a whole plane.

Once the `Main wing` has been defined, it is possible to add some other elements to build a wing system - clicking on the `Plane > Current Plane > Edit` - such as an `Elevator` or a `Fin`, **checking** the corresponding boxes, as shown below.

![alt text](screenshots/plane_01.png)

Then click on the corresponding `Define` buttons to design for example the `Elevator` on the `Wing Edition` window.

![alt text](screenshots/plane_02.png)

The same applies to the `Fin` setting up all the necessary geometrical parameters, as usual.

![alt text](screenshots/plane_03.png)

Then click on the `Save` button to setup each element of the wing system and to save the whole plane. 

![alt text](screenshots/plane_04.png)

As you can see from the `Plane Editor` window it would be possible to define a body too, although it is recommended not to include it in the analysis, since `xflr5` do not employ the `Ring vortex (VLM2)` method on blunt bodies. Thus, it would be meaningless for us to mix up things in this Lab.

## Examples

What follows here below is just a collection of successful wing systems design and analyses (you can find in this directory `xflr5-pp/plane/xfl-projects/`), carried out following the instructions given in this quick guide and in particular within this closing section.

I hope you will get inspired looking at some of them.

### Spitfire elliptical wing

![alt text](/doc/gallery/spitfire-geometry.png)
*Wing geometry: A. Wrobel* <!-- Alexander Wrobel  -->

Here following, it is shown the analysis around a [Spitfire](https://en.wikipedia.org/wiki/Supermarine_Spitfire) with the velocity field over the optimal wing  

![alt text](/doc/gallery/spitfire-velocity.png)
*Velocity field: A. Wrobel* <!-- Alexander Wrobel  -->

and the streamlines with the vortices at the wing tips. 

![alt text](/doc/gallery/spitfire-vortices.png)
*Wingtip vortices: A. Wrobel* <!-- Alexander Wrobel  -->

### F1 rear wing

![alt text](/doc/gallery/DRS-rear-wing.jpg)
*Rear wing: M. Cesarini, G. Chiarolla, A. Di Filippo* <!-- Marco Cesarini, Giovanni Chiarolla, Alfonso Di Filippo -->

Here following, it is shown the [Drag Reduction System](https://en.wikipedia.org/wiki/Drag_reduction_system) (DRS) in closed (top) and open (bottom) positions.

![alt text](/doc/gallery/DRS-closed.jpg)
*Closed DRS: M. Cesarini, G. Chiarolla, A. Di Filippo* <!-- Marco Cesarini, Giovanni Chiarolla, Alfonso Di Filippo -->

![alt text](/doc/gallery/DRS-open.jpg)
*Open DRS: M. Cesarini, G. Chiarolla, A. Di Filippo* <!-- Marco Cesarini, Giovanni Chiarolla, Alfonso Di Filippo -->

###  X-wing starfighters

![alt text](/doc/gallery/x-wing-design.png)
*X-wing fighter: R. D'Agostino, C. De Gennaro, L. Onofri, P. Scarano* <!-- Riccardo D'Agostino, Cristian De Gennaro, Ludovica Onofri, Pasquale Scarano -->

Here following, it is shown the analysis around an [X-wing fighter](https://en.wikipedia.org/wiki/X-wing_fighter), a fictional spacecraft from *Star Wars*.

![alt text](/doc/gallery/x-wing-analysis.png)
*X-wing analysis: R. D'Agostino, C. De Gennaro, L. Onofri, P. Scarano* <!-- Riccardo D'Agostino, Cristian De Gennaro, Ludovica Onofri, Pasquale Scarano -->

###  NACA 4415 on Boeing 737 & Cessna 172 wings

![alt text](/doc/gallery/NACA4415.png)
*NACA 4415: A. Colucci, M. Massa, F. Persico* <!-- Antonio Colucci, Miryam Massa, Federico Persico -->

Here following, it is shown the above mentioned `NACA 4415` airfoil on the [Boeing 737](https://en.wikipedia.org/wiki/Boeing_737) wing

![alt text](/doc/gallery/NACA4415-boeing737.png)
*Boeing 737 wing: A. Colucci, M. Massa, F. Persico* <!-- Antonio Colucci, Miryam Massa, Federico Persico -->

and the same airfoil on the [Cessna 172](https://en.wikipedia.org/wiki/Cessna_172) wing

![alt text](/doc/gallery/NACA4415-cessna172.png)
*Cessna 172 wing: A. Colucci, M. Massa, F. Persico* <!-- Antonio Colucci, Miryam Massa, Federico Persico -->


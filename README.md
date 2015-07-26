This is a demo project written in Swift2.0

# Caravaggio
a stylish color selection button

Caravaggio helps user choosing a color from color palette in a stylish way.
- Caravaggio is highly customizable
```
  //CaravaggioDataSource functions:
  
    func color(sender: CaravaggioButton, index: Int, section: Int) -> UIColor
    func numberOfItems(sender: CaravaggioButton, section: Int) -> Int
    func numberOfSections(sender: CaravaggioButton) -> Int
    func radiusForSectionItems(sender: CaravaggioButton, section: Int) -> CGFloat
    func sizeForButton(sender: CaravaggioButton) -> CGSize
```
 * you can customize color item sizes for different sections and make particular colors stand out.
 * Caravaggio is self-organized and has its intrinsicContentSize: just pin 2 of its edges to a superview and let it handle the rest!
 * Caravaggio has 4 different position types:
  - **Top left**: where button is placed at top left corner
  - **Top right**
  - **Bottom left**
  - **Bottom right**
  
###warning!:
you should use CaravaggioButton in your **xib/storyboard** and with **autolayout**. initWithFrame: is not supported yet :( already you should use autolayout as much as you can, so maybe it won't be supported at all

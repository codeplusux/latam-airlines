#General
Framer.Extras.Hints.disable()

#Fonts
Utils.insertCSS """
	@font-face {
		font-family: "LATAM";
		src: url("fonts/Latam_Sans_Regular.otf");
	}
"""

minMillas.fontFamily = 'LATAM'
maxMillas.fontFamily = 'LATAM'
tituloTooltip.fontFamily = 'LATAM'

Utils.insertCSS """
	@font-face {
		font-family: "LATAM-Bold";
		src: url("fonts/Latam_Sans_Bold.otf");
	}
"""
textMillas.fontFamily = 'LATAM-Bold'
millasFinal.fontFamily = 'LATAM-Bold'
textPesos.fontFamily = 'LATAM-Bold'
txtMillas.fontFamily = 'LATAM-Bold'
txtTooltipMillas.fontFamily = 'LATAM-Bold'
txtTooltipPesos.fontFamily = 'LATAM-Bold'


#Scroll

scroll = new ScrollComponent
	width: 375
	height: 667
	point: Align.center
	borderColor: "gray"
	scrollHorizontal: no
	parent: resumeStep
	speedY: 1

contentHome = new PageComponent
	parent: scroll.content
	width: 375
	height: 1000
	scrollHorizontal: false
	y: 5

contentHome.addPage(body)
contentHome.content.draggable.enabled = false
scroll.speedy = 5

scroll.contentInset =
	top: searchBar.height - 5
	bottom: navTab.height + 16
	
searchBar.style =
	zIndex:"9"

navTab.style =
	zIndex:"10"

scroll.style =
	zIndex:"-1"

closeSlider.style =
	zIndex:"99"

bgPriceComponent.style =
	zIndex: "9"

#CardAnimation
overlay.states.default =
	opacity: 0

overlay.states.a =
	opacity: 0.8

overlay.states.b =
	opacity: 0

priceComponent.states.default =
	y: 454

priceComponent.states.a =
	y: 302
	height: 324

priceComponent.states.b =
	y: 454
	height: 324

priceComponent.states.c =
	y: 64
	height: 562

priceComponent.states.d =
	y: 456
	height: 171

bgPriceComponent.states.default =
	opacity: 1
	y: 456

bgPriceComponent.states.a =
	opacity: 0
	y: 347

bgPriceComponent.states.b =
	opacity: 1
	y: 456

sliderComponent.states.default =
	opacity: 0
	y: 500

sliderComponent.states.a =
	y: 70	
	opacity: 1

sliderComponent.states.b =
	y: 321	
	opacity: 0
	
closeSlider.states.a =
	opacity: 1

closeSlider.states.b =
	opacity: 0
	

showSliderStep.onClick ->

	Utils.delay 0, ->
		overlay.animate "a",
			curve: Bezier.easeInOut
			time: 0.3

		priceComponent.animate "a",
			curve: Bezier.easeInOut
			time: 0.2

		bgPriceComponent.animate "a",
			curve: Bezier.easeIn
			time: 0.1

		sliderComponent.animate "a",
			curve: Bezier.easeInOut
			time: 0.3
			
		closeSlider.animate "a",
			opacity: 1
			time: 0.2

	Utils.delay 1, ->
		priceComponent.animate "c",
			time: 0

closeSlider.onClick ->

	sliderComponent.animate "b",
		curve: Bezier.easeInOut
		time: 0.25
		
	closeSlider.animate "b",
		opacity: 1
		time: 0.25

	overlay.animate "b",
		curve: Bezier.easeInOut
		time: 0.1
	
	bgPriceComponent.animate "b",
		curve: Bezier.easeInOut
		time: 0.3

	priceComponent.animate "d",
		curve: Bezier.easeIn
		time: 0.2

#SliderStep

test = 100000

slider = new SliderComponent
	width: 170
	height: 5
	x: Align.center -59
	y: Align.center -60
	min: 500
	max: 3000
	parent: boxSlider
	borderRadius: 0
	hitArea: 100

slider.fill.backgroundColor = "#008D87"
slider.knob.backgroundColor = "#008D87"
slider.knob.size = 25
slider.animateToValue 500
slider.knob.draggable.momentum = no


slider.onValueChange ->
	millasUsadas = slider.value
	millasUsadas = Utils.round this.value
	x = millasUsadas.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.')
	textMillas.text = x
	millasFinal.text = x
	txtTooltipMillas.text = x + " millas +"
	
	if slider.value > 500
		precioFinal = test - (millasUsadas * 6)
		b = precioFinal.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.')
		textPesos.text = "$" + b
		txtTooltipPesos.text = "$" + b
	else
		precioFinal = test - millasUsadas
		minMillas.animate
			opacity: 1
			time: 0.1
			
	if slider.value == 3000
		maxMillas.animate
			opacity: 1
			time: 0.1
	else
		maxMillas.animate
			opacity: 0
			time: 0.1

	if slider.value <= 510
		minMillas.animate
			opacity: 1
			time: 0.1

	else
		minMillas.animate
			opacity: 0
			time: 0.1


#Tooltip

millasTooltip.parent = slider.knob
millasTooltip.x = Align.center 35
millasTooltip.y = Align.center -70
millasTooltip.style =
	zIndex:"999"
	
millasTooltip.states = 
	closed:
		opacity: 0
		x: Align.center
		y: -30
		scale: 0.2

sliderFlyOut = new Layer
	width: 140
	height: 80
	backgroundColor: "#008D87"
	parent: slider.knob
	x: 10
	y: -90
	borderRadius: 4


sliderFlyOut.states = 
	closed:
		opacity: 0
		x: Align.center
		y: -20
		scale: 0.2

sliderFlyOut.states.switchInstant "closed"
millasTooltip.states.switchInstant "closed"

sliderFlyOut.animationOptions =
	time: 0.2

slider.knob.on Events.DragStart, ->
	sliderFlyOut.states.switchInstant "default"
	millasTooltip.states.switchInstant "default"
	
slider.knob.on Events.DragEnd, ->
	sliderFlyOut.states.switch "closed"
	millasTooltip.states.switchInstant "closed"

#Snippet
# scroll.onMove ->
# 	navTab.y = Utils.modulate scroll.scrollY, [0, 44], [551, 560]
# 	shop.y = Utils.modulate scroll.scrollY, [0, -44], [450, 446]

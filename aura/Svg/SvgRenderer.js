({
  render: function(component, helper) {
    //grab attributes from the component markup
    var classname = component.get("v.class");
    var xlinkhref = component.get("v.xlinkHref");
    var ariaHidden = component.get("v.ariaHidden");

    //return an svg element w/ the attributes
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute('class', classname);
    svg.setAttribute('aria-hidden', ariaHidden);
    var useElement = document.createElementNS('http://www.w3.org/2000/svg', 'use');
    useElement.setAttributeNS(
    	'http://www.w3.org/1999/xlink',
        'href',
        xlinkhref
    );  
    svg.appendChild(useElement);
    return svg;
  }
})
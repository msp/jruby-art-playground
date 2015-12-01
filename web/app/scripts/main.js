// eslint-disable-line no-console

var genetic;
var pixel = 100;
var gen;
var canvasW = 600;

var stats = new Stats();
stats.setMode( 0 ); // 0 FPS, 1 MS

// align top-left
stats.domElement.style.position = 'absolute';
stats.domElement.style.right = '0px';
stats.domElement.style.bottom = '0px';
stats.domElement.style.zIndex = '999999';

document.addEventListener("DOMContentLoaded", function() {
  document.body.appendChild( stats.domElement );
});


function setup() {
  var canvas = createCanvas(canvasW, canvasW);
  canvas.parent('container');
  background(255);

  var num_bits = width / pixel * height / pixel;
  var p_crossover = 0.98;
  var p_mutation = 1.0 / num_bits * 1.5;

  genetic = Opal.Genetic.$new(Opal.hash2(["_num_bits", "_p_crossover", "_p_mutation"],
    {"_num_bits": num_bits, "_p_crossover": p_crossover, "_p_mutation": p_mutation}));

  //noLoop();
}

function draw() {
  stats.begin();

  var xpos = 0;
  var ypos = 0;

  gen = genetic.$next_gen();

  //draw one row
  var bitstring = gen.$fetch('bitstring');

  for (var i = 0; i < bitstring.length; i++) {
    var bit = bitstring.charAt(i);

    //Off / White + grey border
    if (bit == '0') {
      fill(255);
      noStroke();
      //stroke(200);

      //control
      //rect(xpos, ypos, pixel, pixel)

      rect(xpos, ypos, random(pixel*2), random(pixel*2), random(7), random(7), random(7), random(7))
    } else {
      //On / Grey + White border
      //Trends this way
      fill(50, 1);
      //noStroke();

      //control
      //rect(xpos, ypos, pixel, pixel);

      rect(xpos, ypos, pixel*2, pixel*2);
    }

    if (xpos < width) {
      xpos += pixel;
    } else {
      xpos = 0;
      ypos += pixel;
    }
  }

  stats.end();
}



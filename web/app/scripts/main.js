console.log('\'Allo \'Allo!'); // eslint-disable-line no-console

var genetic;
var pixel = 30;

function setup() {

  createCanvas(600, 600);
  background(255);

  var num_bits = width/pixel * height/pixel;
  var p_crossover = 0.98;

  //# control
  var p_mutation = 1.0/num_bits;

  //@genetic =  Genetic.new(_num_bits: num_bits, _p_crossover: p_crossover, _p_mutation: p_mutation)
  genetic = Opal.Genetic.$new(Opal.hash2(["_num_bits", "_p_crossover", "_p_mutation"], {"_num_bits": num_bits, "_p_crossover": p_crossover, "_p_mutation": p_mutation}));
}

function draw() {
  ellipse(50, 50, 80, 80);

  var gen = genetic.$next_gen();

  var xpos = 0;
  var ypos = 0;

  //# draw one row
  //gen.$fetch('bitstring').$each_char do |bit|

  //# Off / White + grey border
  var bit = 0
  if (bit == 0) {
    fill(255);
    //# control
    rect(xpos, ypos, pixel, pixel)
  } else {
    //# On / Grey + White border
    //    # Trends this way

    fill(50);

    //no_stroke();
    //# control
    rect(xpos, ypos, pixel, pixel);
  }

  if (xpos < width) {
    xpos += pixel;
  } else {
    xpos = 0;
    ypos += pixel;
  }
}



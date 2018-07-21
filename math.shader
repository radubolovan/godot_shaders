shader_type canvas_item;

uniform vec3 the_color = vec3(0.0, 0.0, 0.0);

uniform float PI = 3.141592;
uniform float HALF_PI = 1.570796;

uniform vec3 colorA = vec3(1.0, 0.0, 0.0);
uniform vec3 colorB = vec3(0.0, 1.0, 0.0);
uniform vec3 colorC = vec3(0.0, 0.0, 1.0);
uniform vec3 colorD = vec3(0.0, 0.0, 0.0);
uniform vec3 colorE = vec3(1.0, 1.0, 1.0);

/*
 * drawing functions
*/
float plot(vec2 pt, float pct)
{
	return smoothstep(pct - 0.01, pct, pt.y) - smoothstep(pct, pct + 0.01, pt.y);
}

vec2 circle(vec2 origin, float radius, float angle)
{
	float a = origin.x + radius * cos(angle);
	float b = origin.y + radius * sin(angle);
	return vec2(a, b);
}

float disc(in vec2 pt, in float radius)
{
    vec2 dist = pt - vec2(0.5);
	return 1.0 - smoothstep(radius - (radius * 0.01), radius + (radius * 0.01), dot(dist, dist) * 4.0);
}

/*
 * math functions
*/
float the_pow(float x)
{
	return pow(x, 5.0);
}

float func1D_1(float x)
{
	//return step(0.5, x);
	//return smoothstep(0.0, 1.0, x);
	//return mod(x, 0.5);
	//return fract(x);
	//return ceil(x);
	//return floor(x);
	//return sign(x);
	//return abs(x);
	//return clamp(x, 0.0, 1.0);
	//return min(0.0, x);
	return max(0.0, x);
}

float func1D_2(float x, float time)
{
	float amp = 1.0;
	float freq = PI;
	return amp * sin(x * freq * time);
}

float blinnWyvillCosineApproximation(float x)
{
	float x2 = x * x;
	float x4 = x2 * x2;
	float x6 = x4 * x2;

	float fa = 4.0 / 9.0;
	float fb = 17.0 / 9.0;
	float fc = 22.0 / 9.0;
	return fa * x6 - fb * x4 + fc * x2;
}

float doubleCubicSeat(float x, float a, float b)
{
	float epsilon = 0.00001;
	float min_param_a = 0.0 + epsilon;
	float max_param_a = 1.0 - epsilon;
	float min_param_b = 0.0;
	float max_param_b = 1.0;
	a = min(max_param_a, max(min_param_a, a));
	b = min(max_param_b, max(min_param_b, b));
  
	float y = 0.0;
	if(x <= a)
    	y = b - b * pow(1.0 - x / a, 3.0);
	else
		y = b + (1.0 - b) * pow( (x - a) / (1.0 - a), 3.0 );
	return y;
}

float doubleCubicSeatWithLinearBlend(float x, float a, float b)
{
	float epsilon = 0.00001;
	float min_param_a = 0.0 + epsilon;
	float max_param_a = 1.0 - epsilon;
	float min_param_b = 0.0;
	float max_param_b = 1.0;
	a = min(max_param_a, max(min_param_a, a));
	b = 1.0 - min(max_param_b, max(min_param_b, b));
  
	float y = 0.0;
	if(x <= a)
    	y = b * x + (1.0 - b) * a * (1.0 - pow(1.0 - x / a, 3.0));
	else
		y = b * x + (1.0 - b) * (a + (1.0 - a) * pow((x - a) / (1.0 - a), 3.0));
	return y;
}

float doublePolynomialSigmoid(float x, float a, float b, int n)
{
	float y = 0.0;
	if(n % 2 == 0)
	{
    	// even polynomial
		if(x <= 0.5)
			y = pow(2.0 * x, float(n)) / 2.0;
		else
			y = 1.0 - pow(2.0 * (x - 1.0), float(n)) / 2.0;
	}
	else
	{
    	// odd polynomial
    	if(x <= 0.5)
			y = pow(2.0 * x, float(n)) / 2.0;
		else
			y = 1.0 + pow(2.0 * (x - 1.0), float(n)) / 2.0;
	}
	return y;
}

float quadraticThroughAGivenPoint(float x, float a, float b)
{
	float epsilon = 0.00001;
	float min_param_a = 0.0 + epsilon;
	float max_param_a = 1.0 - epsilon;
	float min_param_b = 0.0;
	float max_param_b = 1.0;
	a = min(max_param_a, max(min_param_a, a));  
	b = min(max_param_b, max(min_param_b, b)); 
  
	float A = (1.0 - b) / (1.0 - a) - (b / a);
	float B = (A * (a * a) - b) / a;
	float y = A * (x * x) - B * x;
	y = min(1, max(0, y)); 
  
	return y;
}

float impulse(float k, float x)
{
	float h = k * x;
	return sin( h * exp( 1.0 - h ) );
}

float cubicPulse( float c, float w, float x, float amp )
{
    x = abs(x - c);
    if(x > w )
		return 0.0;
    x /= w;
    return amp - x * x *( 3.0 - 2.0 * x );
}

float parabola( float x, float k )
{
    return pow( 4.0 * x * (1.0 - x), k );
}

float sinc( float x, float k )
{
    float a = PI * (k * x - 1.0);
    return sin(a)/a;
}

float random(float x, float time)
{
	float freq = 10000.0;
	float val = sin(time) * freq;
	float ret = fract(sin(x + time) * val);

	return ret;
}

float step_random(float x, float time)
{
	return random(floor(x), time);
}

float smooth_saw(float x, float time)
{
	return smoothstep(fract(x * time), 0.0, 1.0);
}

float linear(float t)
{
	return t;
}

float exponentialIn(float t)
{
	return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
}

float exponentialOut(float t)
{
	return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

float exponentialInOut(float t)
{
	if(t == 0.0 || t == 1.0)
		return t;
	if(t < 0.5)
		return (+0.5 * pow(2.0, (20.0 * t) - 10.0));
	return (-0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0);
}

float sineIn(float t)
{
	return sin((t - 1.0) * HALF_PI) + 1.0;
}

float sineOut(float t)
{
	return sin(t * HALF_PI);
}

float sineInOut(float t)
{
	return -0.5 * (cos(PI * t) - 1.0);
}

float qinticIn(float t)
{
	return pow(t, 5.0);
}

float qinticOut(float t)
{
	return 1.0 - (pow(t - 1.0, 5.0));
}

float qinticInOut(float t)
{
	if(t < 0.5)
		return +16.0 * pow(t, 5.0);
	return -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float quarticIn(float t)
{
	return pow(t, 4.0);
}

float quarticOut(float t)
{
	return pow(t - 1.0, 3.0) * (1.0 - t) + 1.0;
}

float quarticInOut(float t)
{
	if(t < 0.5)
		return +8.0 * pow(t, 4.0);
    return -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

float quadraticInOut(float t)
{
	float p = 2.0 * t * t;
	return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float quadraticIn(float t)
{
	return t * t;
}

float quadraticOut(float t)
{
	return -t * (t - 2.0);
}

float cubicIn(float t)
{
	return t * t * t;
}

float cubicOut(float t)
{
	float f = t - 1.0;
	return f * f * f + 1.0;
}

float cubicInOut(float t)
{
	if(t < 0.5)
		return 4.0 * t * t * t;
	return 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float elasticIn(float t)
{
	return sin(13.0 * t * HALF_PI) * pow(2.0, 10.0 * (t - 1.0));
}

float elasticOut(float t)
{
	return sin(-13.0 * (t + 1.0) * HALF_PI) * pow(2.0, -10.0 * t) + 1.0;
}

float elasticInOut(float t)
{
	if(t < 0.5)
		return 0.5 * sin(+13.0 * HALF_PI * 2.0 * t) * pow(2.0, 10.0 * (2.0 * t - 1.0));
	return 0.5 * sin(-13.0 * HALF_PI * ((2.0 * t - 1.0) + 1.0)) * pow(2.0, -10.0 * (2.0 * t - 1.0)) + 1.0;
}

float circularIn(float t)
{
	return 1.0 - sqrt(1.0 - t * t);
}

float circularOut(float t)
{
	return sqrt((2.0 - t) * t);
}

float circularInOut(float t)
{
	if(t < 0.5)
		return 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t));
	return 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
}

float bounceOut(float t)
{
	float a = 4.0 / 11.0;
	float b = 8.0 / 11.0;
	float c = 9.0 / 10.0;

	float ca = 4356.0 / 361.0;
	float cb = 35442.0 / 1805.0;
	float cc = 16061.0 / 1805.0;

	float t2 = t * t;

	if(t < a)
		return 7.5625 * t2;
    if(t < b)
		return 9.075 * t2 - 9.9 * t + 3.4;
    if(t < c)
		return ca * t2 - cb * t + cc;
	return 10.8 * t * t - 20.52 * t + 10.72;
}

float bounceIn(float t)
{
	return 1.0 - bounceOut(1.0 - t);
}

float bounceInOut(float t)
{
	if(t < 0.5)
		return 0.5 * (1.0 - bounceOut(1.0 - t * 2.0));
	return 0.5 * bounceOut(t * 2.0 - 1.0) + 0.5;
}

float backIn(float t)
{
	return pow(t, 3.0) - t * sin(t * PI);
}

float backOut(float t)
{
	float f = 1.0 - t;
	return 1.0 - (pow(f, 3.0) - f * sin(f * PI));
}

float backInOut(float t)
{
	float f = 0.0;
	if(t < 0.5)
		f = 2.0 * t;
	else
		f = 1.0 - (2.0 * t - 1.0);

	float g = pow(f, 3.0) - f * sin(f * PI);

	if(t < 0.5)
		return 0.5 * g;
	return 0.5 * (1.0 - g) + 0.5;
}

/*
 * translate x and y from
 * up_left (0, 0), down_right(1, 1)
 * to
 * down_left (-2 * PI, -2), up_right(2 * PI, 2) <- the_x, the_y
 * and to to
 * down_left (-2 * PI, 0), up_right(2 * PI, 1) <- the_x, the_y_2
*/
float the_x(float x)
{
	return x * 4.0 * PI - 2.0 * PI;
}

float the_y_1(float y)
{
	return (1.0 - y) * 0.125 + 0.125;
}

float the_y_2(float y)
{
	return 1.0 - y;
}

void mix_colors_1(float x, out vec3 color)
{
	color.r = smoothstep(the_x(0.0), the_x(1.0), x);
	color.g = sin(x * PI);
	color.b = pow(x, the_x(0.5));
}

void mix_colors_2(vec2 pt, out vec3 color)
{
	vec3 pct = vec3(pt.x);

	vec3 colorX = vec3(0.149, 0.141, 0.912);
	vec3 colorY = vec3(1.000, 0.833, 0.224);

	color = mix(colorX, colorY, pct);

	//color = mix(color, vec3(1.0, 0.0, 0.0), plot(vec2(the_x(pt.x), the_y_2(pt.y)), pct.r));
	color = mix(color, vec3(0.0, 1.0, 0.0), plot(vec2(the_x(pt.x), the_y_2(pt.y)), pct.g));
	//color = mix(color, vec3(0.0, 0.0, 1.0), plot(vec2(the_x(pt.x), the_y_2(pt.y)), pct.b));
}

void mix_colors_3(vec2 uv, out vec3 color, float time)
{
	color = mix(colorB, colorC, vec3(abs(sin(uv.x * PI * 0.125 + time))));
}

void mix_colors_4(vec2 uv, out vec3 color)
{
	color = mix(colorD, colorE, vec3(bounceInOut(uv.x * 0.125)));
}

vec3 rgb2hsb( in vec3 c )
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsb2rgb( in vec3 c )
{
	vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0), 6.0)-3.0)-1.0, 0.0, 1.0 );
	rgb = rgb * rgb * (3.0 - 2.0 * rgb);
	return c.z * mix(vec3(1.0), rgb, c.y);
}

vec4 disc2(float radius, vec2 pt, vec3 clr)
{
	float y = step(distance(pt, vec2(radius)), radius);
	return vec4(y * clr, 1.0);
}

void fragment()
{
	float time = TIME;

	/*
	//float y = blinnWyvillCosineApproximation(UV.x);
	//float y = doubleCubicSeatWithLinearBlend(UV.x, 0.3, 0.7);
	//float y = doublePolynomialSigmoid(UV.x, 0.3, 0.7, 2);
	//float y = quadraticThroughAGivenPoint(UV.x, 0.3, 0.7);
	//float y = impulse(1.0, the_x(UV.x));
	//float y = cubicPulse(0.5, 0.5, the_x(UV.x), 1.0);
	//float y = parabola(the_x(UV.x), 1.0);
	//float y = sinc(the_x(UV.x), abs(sin(TIME)));
	float y = random(the_x(UV.x), time / 10000.0);

	float pct = plot( UV, the_y(y) );
	vec3 color = (1.0 - pct) + pct * the_color;
	*/

	/*
	float y = distance(UV,vec2(0.5));
	vec3 color = vec3(y);
	if(y > 0.2)
		color = vec3(1.0);
	if(y < 0.1970)
		color = vec3(1.0);
	*/

	/*
	float y = disc(UV, 0.1);
	vec3 color = vec3(y);
	*/

	/*
	vec3 color = vec3(0.0);
	vec2 pt = UV * 2.0 - 1.0;
	float d = length( abs(pt) - 0.5 );

	COLOR = vec4(vec3(fract(d * 10.0)),1.0);
	//COLOR = vec4(vec3( step(0.3, d) ), 1.0);
	//COLOR = vec4(vec3( step(0.3, d) * step(d, 0.4)), 1.0);
	//COLOR = vec4(vec3( smoothstep(0.2, 0.3, d) * smoothstep( 0.6, 0.3, d)) ,1.0);
	//*/

	/*
	vec3 colorA = vec3(0.149, 0.141, 0.912); //blue
	vec3 colorB = vec3(1.000, 0.833, 0.224); // yellow
	//float pct = abs(sin(time)); // percent between 0 and 1
	//float pct = 0.3; // percent between 0 and 1
	float pct = sinc(0.5, abs(sin(TIME))); // percent between 0 and 1
	vec3 color = vec3(0.0);
	color = mix(colorA, colorB, pct);
	COLOR = vec4(color, 1.0);
	*/

	/*
	vec3 colorA = vec3(0.149,0.141,0.912);
	vec3 colorB = vec3(1.000,0.833,0.224);

	float t = time * 0.5;
	float pct = cubicInOut( abs(fract(t) * 2.0 - 1.0) );
	COLOR = vec4(vec3(mix(colorA, colorB, pct)),1.0);
	*/

	/*
	vec3 color;
	mix_colors_1(the_x(UV.x), color);
	COLOR = vec4(color,1.0);
	//*/

	/*
	vec3 color;
	mix_colors_2(UV, color);
	COLOR = vec4(color, 1.0);
	*/

	/*
	vec3 color;
	mix_colors_3(vec2(the_x(UV.x), the_y_1(UV.y)), color, TIME);
	COLOR = vec4(color,1.0);
	//*/

	/*
	vec3 color;
	mix_colors_4(vec2(the_x(UV.x), the_y_1(UV.y)), color);
	float y = disc(vec2(UV.x, UV.y * 2.0 - 0.5), color.r);
	COLOR = vec4(vec3(y, y, y), 1.0);
	//*/

	/*
	vec3 color;
	mix_colors_3(vec2(the_x(UV.x), the_y_1(UV.y)), color, TIME);
	//mix_colors_4(vec2(the_x(UV.x), the_y_1(UV.y)), color);
	vec2 pt = UV * 2.0 - 1.0;
	float d = length( 0.2 - abs(pt) );
	color += d * HALF_PI;
	COLOR = vec4(color, 1.0);
	*/

	/*
	vec2 origin = vec2(0.5, 0.5);
	float radius = 0.3;
	vec2 v = vec2(UV) - origin;
	float len = length(v);
	float diff = abs(len - radius);
	float thickness = 0.05;
	float cyan = smoothstep( 0.0, thickness, diff);
	vec3 color = vec3(1.0 - cyan, 0.0, 0.0);
	//COLOR = vec4(color, 1.0);
	COLOR = vec4(color, 1.0 - cyan);
	//*/

	/*
	vec2 origin = vec2(0.5, 0.5);
	float radius = 0.3;
	vec2 v = vec2(UV) - origin;
	float len = length(v);
	float diff = abs(len - radius);
	float thickness = 0.05;
	float cyan = smoothstep( 0.0, thickness, diff);
	float red = 1.0 - cyan;
	vec3 color = vec3(1.0, 1.0-red, 1.0-red);
	COLOR = vec4(color, 1.0);
	//*/

	/*
	vec3 color = hsb2rgb(vec3(UV.x, 1.0, the_y_2(UV.y)));
	COLOR = vec4(color, 1.0);
	*/

	/*
	float size = 0.01;
	vec2 tl = step(vec2(size), UV);
	vec2 br = step(vec2(size), 1.0 - UV);
	vec2 tl1 = smoothstep(size, 1.0, UV);
	vec2 br1 = smoothstep(size, 1.0, 1.0 - UV);
	vec3 color = vec3( tl1.x * tl1.y * br1.x * br1.y );
	COLOR = vec4(color, 1.0);
	//*/

	/*
	vec2 v1 = 1.0 - step(vec2(0.08, 0.2), UV);
	vec2 v2 = step(vec2(0.10, 0.22), UV);
	vec2 v3 = step(vec2(0.24, 0.2), UV);
	vec2 v4 = 1.0 - step(vec2(0.0, 0.44), UV);
	float red = (v1.x + v2.x - v3.x + v4.x) * (v1.y + v2.y - v3.y + v4.y);

	vec2 v5 = step(vec2(0.7, 0.9), UV);
	vec2 v6 = step(vec2(0.94, 1.0), UV);
	vec2 v7 = step(vec2(0.96, 0.9), UV);
	float blue = (v5.x - v6.x + v7.x) * (v5.y - v6.y + v7.y);

	vec2 v8 = step(vec2(0.96, 0.0), UV);
	vec2 v9 = step(vec2(1.0, 0.2), UV);
	vec2 v10 = step(vec2(0.96, 0.22), UV);
	vec2 v11 = step(vec2(1.0, 0.44), UV);
	float yellow = (v8.x - v9.x + v10.x - v11.x) * (v8.y - v9.y + v10.y - v11.y);

	vec2 v100 = step(vec2(0.24, 0.0), UV);
	vec2 v101 = step(vec2(0.26, 0.0), UV);
	vec2 v102 = step(vec2(0.68, 0.0), UV);
	vec2 v103 = step(vec2(0.70, 0.0), UV);
	vec2 v104 = step(vec2(0.94, 0.0), UV);
	vec2 v105 = step(vec2(0.96, 0.0), UV);
	vec2 v106 = step(vec2(0.24, 0.20), UV);
	vec2 v107 = step(vec2(0.26, 0.22), UV);
	vec2 v108 = step(vec2(0.0, 0.44), UV);
	vec2 v109 = step(vec2(0.0, 0.46), UV);
	vec2 v110 = step(vec2(0.24, 0.88), UV);
	vec2 v111 = step(vec2(0.26, 0.9), UV);
	float white = (1.0 - v100.x + v101.x - v102.x + v103.x - v104.x + v105.x - v106.x + v107.x - v108.x + v109.x) *
					(1.0 - v100.y + v101.y - v102.y + v103.y - v104.y + v105.y - v106.y + v107.y - v108.y + v109.y) - (v110.x) * (v110.y) + v111.x * v111.y;

	vec3 color;
	if(UV.x < 0.24 && UV.y < 0.44)
		color = vec3( red, 0.0, 0.0 );
	else if(UV.x > 0.7 && UV.y > 0.9)
		color = vec3( 0.0, 0.0, blue );
	else if(UV.x > 0.96 && UV.y < 0.44)
		color = vec3( yellow, yellow, 0.0 );
	else
		color = vec3( white, white, white );

	COLOR = vec4(color, 1.0);
	//*/
	
	/*
	float pct = 1.0 - smoothstep(distance(UV, vec2(0.5)), 0.1, 0.12);
	vec3 color = vec3(pct);
	float alpha = color.r;
	if(color.r < 0.3)
		alpha = 0.0;
	COLOR = vec4(color + vec3(0.0, 1.0, 0.0), alpha);
	//*/

	/*
	float pct = distance(UV, vec2(0.5)) / 2.0;
	vec3 color = vec3(pct) + vec3(UV.x, UV.y, 0.0);
	COLOR = vec4(color, 1.0);
	//*/

	/*
	float y = disc(UV, max(abs(sin(TIME)) * 0.5, 0.1));
	vec3 color = vec3(UV * 0.5, y);
	COLOR = vec4(color, 1.0);
	//*/
	
	//COLOR = disc2(0.5, UV, vec3(1.0, 0.0, 0.0));

	//*
	//float y = distance(UV, vec2(0.4));
	//float y = distance(UV, vec2(0.4)) + distance(UV, vec2(0.6));
	//float y = distance(UV, vec2(0.4)) * distance(UV, vec2(0.6));
	//float y = min(distance(UV, vec2(0.4)), distance(UV, vec2(0.6)));
	//float y = max(distance(UV, vec2(0.4)), distance(UV, vec2(0.6)));
	float y = pow(distance(UV, vec2(0.4)), distance(UV, vec2(0.6)));
	COLOR = vec4(vec3(y), 1.0);
	//*/
}

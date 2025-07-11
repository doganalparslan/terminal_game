@tool
extends RichTextEffect
class_name GlitchEffect

# Define the BBCode tag name for this effect
var bbcode = "glitch"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
# 1. Get BBCode parameters (with defaults if not provided)
	var speed     = char_fx.env.get("speed", 10.0)      # updates per second
	var intensity = char_fx.env.get("intensity", 1.0)   # 0.0 to 1.0
	var duration  = char_fx.env.get("duration", 0.0)    # total time (0 = infinite)

# 2. Handle duration: if time exceeded, end glitch by fixing alpha at 1
	if duration > 0.0 and char_fx.elapsed_time > duration:
		char_fx.color.a = 1.0  # ensure fully opaque after effect duration
		return true

# 3. Compute a random alpha for this character based on time and index
	var elapsed = char_fx.elapsed_time
	var step = int(floor(elapsed * speed))  # current flicker step
# Combine step and character index to get a pseudo-random seed:
	var seed = float(step) * 78.233 + float(char_fx.range.x) * 12.9898
# Generate a pseudo-random value in [0,1)
	var sine_val = sin(seed)
	var rand_val = sine_val - floor(sine_val)  # fract(sin(seed))
# Calculate flicker alpha based on intensity
	var flicker_alpha = 1.0 - intensity * rand_val

# 4. Apply the alpha to the character's color
	char_fx.color.a *= flicker_alpha
	return true

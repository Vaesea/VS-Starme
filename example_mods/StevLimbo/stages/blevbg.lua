local shadname = "stridentCrisisWavy"

	function onCreatePost()
		initLuaShader("stridentCrisisWavy")
		setSpriteShader('void', shadname)
	end
	
	function onUpdate(elapsed)
	setShaderFloat('void', 'uWaveAmplitude', 0.1)
	setShaderFloat('void', 'uFrequency', 5)
	setShaderFloat('void', 'uSpeed', 2.25)
		end

	function onUpdatePost(elapsed)
	setShaderFloat('void', 'uTime', os.clock())
	end
local shadname = "stridentCrisisWavy"

	function onCreatePost()
		initLuaShader("stridentCrisisWavy")
		setSpriteShader('thing', shadname)
	end
	
	function onUpdate(elapsed)
	setShaderFloat('thing', 'uWaveAmplitude', 0.1)
	setShaderFloat('thing', 'uFrequency', 5)
	setShaderFloat('thing', 'uSpeed', 2.25)
		end

	function onUpdatePost(elapsed)
	setShaderFloat('thing', 'uTime', os.clock())
	end
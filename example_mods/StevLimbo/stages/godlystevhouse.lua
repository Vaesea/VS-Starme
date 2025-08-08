local shadname = "stridentCrisisWavy"

	function onCreatePost()
		initLuaShader("stridentCrisisWavy")
		setSpriteShader('house', shadname)
	end
	
	function onUpdate(elapsed)
	setShaderFloat('house', 'uWaveAmplitude', 0.1)
	setShaderFloat('house', 'uFrequency', 5)
	setShaderFloat('house', 'uSpeed', 2.25)
		end

	function onUpdatePost(elapsed)
	setShaderFloat('house', 'uTime', os.clock())
	end
package states;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class FreeplaySelectState extends MusicBeatState {
	public static var freeplayCats:Array<String> = ['main', 'maintwo', 'extra'];
	public static var curCategory:Int = 0;

	var curSelected:Int = 0;
	var isTweening:Bool = false;

	var BG:FlxSprite;
	var vignette:FlxSprite;

	var categoryIcon:FlxSprite;
	var iconShadow:FlxSprite;

	var tutorialText:FlxText;

	var iconXCenter:Float;
	var iconY:Float;

	override function create() {
		// Background with color tint
		BG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		BG.screenCenter();
		BG.color = 0xFF4965FF ;
		add(BG);

		// Vignette overlay
		vignette = new FlxSprite();
		vignette.makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
		add(vignette);

		// Positioning for icons
		iconXCenter = FlxG.width / 2;
		iconY = FlxG.height / 2 - 80;

		// Shadow sprite
		iconShadow = new FlxSprite(iconXCenter + 6, iconY + 6);
		iconShadow.alpha = 0.25;
		iconShadow.color = FlxColor.BLACK;
		add(iconShadow);

		// Main category icon
		categoryIcon = new FlxSprite(iconXCenter, iconY);
		categoryIcon.scale.set(1, 1);
		add(categoryIcon);


		// Instructional text
		tutorialText = new FlxText(0, FlxG.height - 40, FlxG.width,
			"Left / Right to change category   |   ENTER to select   |   ESC to return");
		tutorialText.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, FlxTextAlign.CENTER);
		tutorialText.scrollFactor.set();
		tutorialText.alpha = 0.9;
		add(tutorialText);
		FlxTween.tween(tutorialText, { alpha: 0.4 }, 2, { type: FlxTween.PINGPONG });

		// Initial icon load
		updateCategoryDisplay(true);

		super.create();
	}

	override function update(elapsed:Float) {
		if (!isTweening) {
			if (controls.UI_LEFT_P) changeSelection(-1);
			if (controls.UI_RIGHT_P) changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'));
			MusicBeatState.switchState(new FreeplayState());
		}

		curCategory = curSelected;
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0) {
		if (isTweening || freeplayCats.length <= 1 || change == 0) return;

		var newSelected = (curSelected + change + freeplayCats.length) % freeplayCats.length;
		if (newSelected == curSelected) return;

		isTweening = true;

		var oldX = categoryIcon.x;
		var direction = change > 0 ? 1 : -1;
		var slideDistance = 360 * direction;

		// Animate icon out
		FlxTween.tween(categoryIcon, { x: oldX - slideDistance, alpha: 0 }, 0.3, {
			ease: FlxEase.quadIn,
			onComplete: function(_) {
				curSelected = newSelected;

				var newCat = freeplayCats[curSelected].toLowerCase();

				// Load new icon & shadow
				categoryIcon.loadGraphic(Paths.image('category/category-' + newCat));
				categoryIcon.updateHitbox();
				categoryIcon.x = oldX + slideDistance;
				categoryIcon.alpha = 0;

				iconShadow.loadGraphic(Paths.image('category/category-' + newCat));
				iconShadow.updateHitbox();
				iconShadow.x = categoryIcon.x + 6;
				iconShadow.y = categoryIcon.y + 6;

				// Animate icon in
				FlxTween.tween(categoryIcon, { x: oldX, alpha: 1 }, 0.3, {
					ease: FlxEase.quadOut,
					onComplete: function(_) {
						FlxTween.tween(categoryIcon.scale, { x: 1.2, y: 1.2 }, 0.1, {
							ease: FlxEase.circOut,
							onComplete: function(_) {
								FlxTween.tween(categoryIcon.scale, { x: 1, y: 1 }, 0.15, {
									ease: FlxEase.quadIn
								});
								isTweening = false;
								FlxG.sound.play(Paths.sound('scrollMenu'));
							}
						});

						// Animate shadow too
						FlxTween.tween(iconShadow, { x: categoryIcon.x + 6, alpha: 0.25 }, 0.2);
					}
				});
			}
		});
	}

	function updateCategoryDisplay(immediate:Bool = false) {
		var curCat:String = freeplayCats[curSelected].toLowerCase();

		// Avoid reloading same image
		if (categoryIcon.graphic != null && categoryIcon.graphic.key == 'category/category-' + curCat)
			return;

		categoryIcon.loadGraphic(Paths.image('category/category-' + curCat));
		categoryIcon.updateHitbox();
		categoryIcon.screenCenter();

		iconShadow.loadGraphic(Paths.image('category/category-' + curCat));
		iconShadow.updateHitbox();
		iconShadow.x = categoryIcon.x + 6;
		iconShadow.y = categoryIcon.y + 6;

		if (immediate) {
			categoryIcon.alpha = 1;
			categoryIcon.scale.set(1, 1);
			iconShadow.alpha = 0.25;
		}
	}
}






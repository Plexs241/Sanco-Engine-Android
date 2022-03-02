package test;

import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import haxe.io.Path;
import sys.FileSystem;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;

class ExtMusicState extends MusicBeatState
{
    var songs:Array<String> = [];
    var songsInstPaths:Array<String> = [];
    var songsVoicesPaths:Array<String> = [];
    private var grpSongs:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var leText:String;
    var checkText:FlxText;
    var songCheck:Array<String> = [];
    var text:FlxText;

    var inst:FlxSound;
    var vocals:FlxSound;

    override function create()
    {
        var initSongList = CoolUtil.coolTextFile(StorageVariables.CustomSF);
        for(i in 0...initSongList.length)
        {
            songs.push(initSongList[i]);
            var theInstName:String = "Inst." + Paths.SOUND_EXT;
            var theVoiceName:String = "Voices." + Paths.SOUND_EXT;
            var possibleInstPath:String = Path.join([StorageVariables.SongsRPath, initSongList[i], theInstName]);
            var possibleVoicePath:String = Path.join([StorageVariables.SongsRPath, initSongList[i], theVoiceName]);
            trace("Pushing possible inst path");
            songsInstPaths.push(possibleInstPath);
            trace("Pushing possible voice path");
            songsVoicesPaths.push(possibleVoicePath);
            if(FileSystem.exists(songsInstPaths[i]) && FileSystem.exists(songsVoicesPaths[i])){
                trace("Existing voice and inst");
                songCheck.push("Voice and Inst");
            } else if (FileSystem.exists(songsInstPaths[i]) && !FileSystem.exists(songsVoicesPaths[i])) {
                trace("Existing inst");
                songCheck.push("Only Inst");
            } else {
                trace("fuck");
                songCheck.push("None");
            }
            trace(songsInstPaths[i]);
            trace(songsVoicesPaths[i]);
        }

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

        grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

        for(i in 0...songs.length)
        {
            var songsText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true ,false);
            songsText.isMenuItem = true;
            songsText.targetY = i;
            grpSongs.add(songsText);
        }

        checkText = new FlxText(FlxG.width * 0.7, 5, 0, "waitin", 32);
        checkText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

        var pathBG:FlxSprite = new FlxSprite(checkText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		pathBG.alpha = 0.6;
		add(pathBG);

        add(checkText);

        var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

        text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

        changeSelection();

        addVirtualPad(UP_DOWN, A_B);

        FlxG.sound.music.stop();

        super.create();
    }

    override function update(elapsed:Float)
    {
        if(controls.BACK){
            FlxG.switchState(new MainMenuState());
        }

        if(controls.UI_UP_P)
            changeSelection(-1);
        if(controls.UI_DOWN_P)
            changeSelection(1);

        if(controls.ACCEPT){
            trace("trying to play");
            FlxG.sound.destroy();
            
            play();

            //inst = new FlxSound().loadStream(songsInstPaths[curSelected], true, false);
            //inst.loadStream(songsInstPaths[curSelected], true, false);
            //vocals.loadStream(songsVoicesPaths[curSelected], true, false);
            //inst.play();
            //vocals.play();
            //FlxG.sound.stream(songsVoicesPaths[curSelected], 1, false, null, false, null, null );
            //FlxG.sound.stream(songsInstPaths[curSelected], 1, false, null, false, null, null );
        }

        super.update(elapsed);
    }

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;

        if(curSelected < 0)
            curSelected = songs.length - 1;
        if(curSelected >= songs.length)
            curSelected = 0;

        var bullShit:Int = 0;

        FlxG.sound.destroy();
        play();
        //inst.loadStream(songsInstPaths[curSelected], true, false);
        //vocals.loadStream(songsVoicesPaths[curSelected], true, false);
        //inst.play();
        //vocals.play();

        //FlxG.sound.stream(songsVoicesPaths[curSelected], 1, false, null, false, null, null );
        //FlxG.sound.stream(songsInstPaths[curSelected], 1, false, null, false, null, null);

        for (item in grpSongs.members){
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;

            if(item.targetY == 0)
                item.alpha = 1;
        }

        checkText.text = songCheck[curSelected];
        text.text = songsInstPaths[curSelected];
    }

    function play(){
        if(songCheck[curSelected] == "Voice and Inst"){
            vocals = new FlxSound().loadStream(songsVoicesPaths[curSelected]);
        } 
        else
            vocals = new FlxSound();

        FlxG.sound.list.add(vocals);
        FlxG.sound.list.add(new FlxSound().loadStream(songsInstPaths[curSelected]));
    }
}
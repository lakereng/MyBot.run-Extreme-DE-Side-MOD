; TogglePause

HotKeySet("{PAUSE}", "TogglePause")

Func TogglePause()
	TogglePauseImpl("Button")
EndFunc

Func TogglePauseImpl($Source)
   Local $BlockInputPausePrev
	$TPaused = NOT $TPaused
	If $TPaused and $Runstate = True Then
		TrayTip($sMODTitle, "", 1)
		TrayTip($sMODTitle, "was Paused!", 1, $TIP_ICONEXCLAMATION)
		Setlog("Bot was Paused!",$COLOR_RED)
		If Not $bSearchMode Then
			$iTimePassed += Int(TimerDiff($sTimer))
			AdlibUnRegister("SetTime")
		EndIf
		PushMsg("Pause", $Source)
		 If $BlockInputPause>0 Then	 $BlockInputPausePrev=$BlockInputPause
		 If $BlockInputPause>0 Then  _BlockInputEx(0,"","",$HWnD)
		GUICtrlSetState($btnPause, $GUI_HIDE)
		GUICtrlSetState($btnResume, $GUI_SHOW)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_ENABLE)
	ElseIf $TPaused = False And $Runstate = True Then
		TrayTip($sMODTitle, "", 1)
		TrayTip($sMODTitle, "was Resumed.", 1, $TIP_ICONASTERISK)
		Setlog("Bot was Resumed.",$COLOR_GREEN)
		If Not $bSearchMode Then
			$sTimer = TimerInit()
			AdlibRegister("SetTime", 1000)
		EndIf
		PushMsg("Resume", $Source)
		 If $BlockInputPausePrev>0 Then  _BlockInputEx($BlockInputPausePrev,"","",$HWnD)
		 If $BlockInputPausePrev>0 Then $BlockInputPausePrev=0
		GUICtrlSetState($btnPause, $GUI_SHOW)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_DISABLE)
	EndIf
	Local $counter = 0
	While $TPaused ; Actual Pause loop
		If _Sleep($iDelayTogglePause1) Then ExitLoop
		$counter = $counter + 1
	    If $pEnabled = 1 or $pEnabled2 = 1 AND $pRemote = 1 AND $counter = 200 Then
	    _RemoteControl()
		$counter = 0
		EndIf
	WEnd
	; everything below this WEnd is executed when unpaused!
	ZoomOut()
	If _Sleep($iDelayTogglePause2) Then Return
EndFunc
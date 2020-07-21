import sdl2, sdl2/gfx
import strformat



proc gfx_example(render: RendererPtr, fpsman: var FpsManager) =
  let limit = 120
  let frames = int16(fpsman.getFramecount())
  let red:   uint32 = 0xff3232ffu32  # (r: 255u8, g:  50u8, b:  50u8, a: 255u8)
  let green: uint32 = 0x32ff32ffu32  # (r:  50u8, g: 255u8, b:  50u8, a: 255u8)
  let blue:  uint32 = 0x3232ffffu32  # (r:  50u8, g:  50u8, b: 255u8, a: 255u8)
  let black: uint32 = 0x000000ffu32  # (r:   0u8, g:   0u8, b:   0u8, a: 255u8)
  let white: uint32 = 0xffffffffu32  # (r: 255u8, g: 255u8, b: 255u8, a: 255u8)
  render.pixelColor(100+frames, 100, green)
  render.lineColor(10, 10, 25+frames, 25+frames, red)
  render.thickLineColor(10, 15, 10+frames, 120, 3, white)
  render.aaLineColor(100, frames, 300, 20-frames, white)
  render.hlineColor(40, 350+frames, 2*frames, blue)
  render.vlineColor(40, 350+frames, 5*frames, green)
  render.rectangleColor(75+frames, 90+frames, 100+frames, 100+frames, white)
  render.roundedRectangleColor(110, 300, 170+frames, 400+frames, 10, white)
  render.boxColor(175+frames, 190+frames, 200+frames, 200+frames, red)
  render.roundedBoxColor(120, 310, 160+frames, 390+frames, 5, blue)
  render.arcColor(320, 240, 100, 0, frames.int16, red)
  render.circleColor(320, 240, 80, white)
  render.aaCircleColor(320, 240, 70, white)
  render.filledCircleColor(320, 240, 50, white)
  render.ellipseColor(500, 200, 70, 10+frames, green)
  render.aaEllipseColor(500, 200, 60, 5+frames, white)
  render.filledEllipseColor(500, 200, 40, frames, blue)
  render.pieColor(640, 500, 80, 0, frames, red)
  render.filledPieColor(640, 400, 60, 0, frames*3, blue)
  render.trigonColor(700, 10, 750, 10, 750, 60, red)
  render.aaTrigonColor(700, 5, 740, 5, 740, 70, green)
  render.filledTrigonColor(650, 40, 690, 50, 700, 90, blue)
  let
    p1 = [100i16, 220, 430, 317, 50]
    p2 = [30i16, 70, 200, 300, 500]
    p3 = [140i16, 260, 470, 357, 90]
    p4 = [70i16, 110, 240, 340, 540]
    p5 = [400i16, 520, 730, 617, 350]
    p6 = [430i16, 470, 600, 700, 900]
    p7 = [70i16, 43, 23, 388, 239, 584, 444]
    p8 = [546i16, 323, 110, 5, 483, 673, 332]
    pt1: ptr int16 = unsafeAddr p1[0]
    pt2: ptr int16 = unsafeAddr p2[0]
    pt3: ptr int16 = unsafeAddr p3[0]
    pt4: ptr int16 = unsafeAddr p4[0]
    pt5: ptr int16 = unsafeAddr p5[0]
    pt6: ptr int16 = unsafeAddr p6[0]
    pt7: ptr int16 = unsafeAddr p7[0]
    pt8: ptr int16 = unsafeAddr p8[0]
  render.polygonColor(pt1, pt2, 5.cint, green)
  render.aaPolygonColor(pt3, pt4, 5.cint, blue)
  render.filledPolygonRGBA(pt5, pt6, 5.cint, 200, 20, 20, 128)
  render.bezierRGBA(pt7, pt8, 7.cint, 5.cint, 255, 0, 255, 255)
  render.present


proc main =
  discard sdl2.init(INIT_EVERYTHING)

  var
    window: WindowPtr
    render: RendererPtr

  window = createWindow("sample_002_keyevent.nim", 100, 100, 640,480, SDL_WINDOW_SHOWN)
  render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)
  defer:
    destroy render
    destroy window
    sdl2.quit()
  var
    evt = sdl2.defaultEvent
    runGame = true
    fpsman: FpsManager
  fpsman.setFramerate(60.cint)
  fpsman.init

  while runGame:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        echo "Quit event: " & $evt
        runGame = false
        break

      case evt.kind
      of KeyDown, KeyUp:
        let scancode = evt.key.keysym.scancode
        case scancode
        of SDL_SCANCODE_UP: echo "Key = up arrow, Code = " & $scancode
        of SDL_SCANCODE_RIGHT: echo "Key = right arrow, Code = " & $scancode
        of SDL_SCANCODE_DOWN: echo "Key = down arrow, Code = " & $scancode
        of SDL_SCANCODE_LEFT: echo "Key = left arrow, Code = " & $scancode
        of SDL_SCANCODE_ESCAPE:
          echo "Escape!"
          runGame = false
        else:
          echo fmt"keysym: {evt.key.keysym}, KeyCode: {$scancode}"
          discard
      else:
        discard


    let dt = fpsman.getFramerate() / 1000
    render.setDrawColor 0,0,0,255
    render.clear
    gfx_example(render, fpsman)
    render.present
    fpsman.delay

main()

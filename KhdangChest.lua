<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>KhDang-Auto-Chest V1</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            user-select: none;
            -webkit-tap-highlight-color: transparent;
        }
        body {
            background: #0a0a0f;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            padding: 12px;
            overflow: hidden;
        }
        .drag-wrapper {
            position: relative;
            width: 100%;
            max-width: 420px;
            margin: 0 auto;
            touch-action: none;
            cursor: grab;
            transition: filter 0.2s;
            z-index: 10;
        }
        .drag-wrapper:active {
            cursor: grabbing;
        }
        .chest-card {
            background: linear-gradient(145deg, #1e1a2b, #14101f);
            border-radius: 36px;
            padding: 20px 18px 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,215,100,0.15);
            backdrop-filter: blur(2px);
            position: relative;
            overflow: hidden;
            border: 1px solid #ffd96644;
            transition: all 0.3s ease;
        }
        .chest-card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 400"><rect width="500" height="400" fill="%231a1428"/><circle cx="120" cy="100" r="60" fill="%23ffb3c6" opacity="0.25"/><circle cx="380" cy="280" r="80" fill="%23b8a9c9" opacity="0.2"/><circle cx="250" cy="180" r="100" fill="%23f2d9e6" opacity="0.12"/><path d="M150 300 L200 240 L250 290 L300 220 L350 270 L400 230 L430 280" stroke="%23ffe4b5" stroke-width="4" fill="none" opacity="0.25"/><circle cx="80" cy="320" r="35" fill="%23ffd9b3" opacity="0.2"/><circle cx="420" cy="70" r="45" fill="%23c9b1d9" opacity="0.2"/></svg>') center/cover no-repeat;
            opacity: 0.5;
            pointer-events: none;
            border-radius: 36px;
        }
        .chest-content {
            position: relative;
            z-index: 2;
        }
        .chest-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
            padding-bottom: 6px;
            border-bottom: 1px solid #ffd96633;
        }
        .chest-title {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            background: linear-gradient(135deg, #feda7a, #fccf5c);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-shadow: 0 0 12px #fbbf2440;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .chest-title small {
            font-size: 0.75rem;
            font-weight: 400;
            color: #b8a5d9;
            background: #2a1f3b;
            padding: 2px 10px;
            border-radius: 40px;
            letter-spacing: 0.3px;
            background: #2f2342;
            color: #d9c7ff;
        }
        .header-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .icon-btn {
            background: rgba(255,215,100,0.08);
            border: 1px solid #ffd96644;
            color: #f5e3c9;
            width: 36px;
            height: 36px;
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            font-weight: 500;
            transition: 0.2s;
            backdrop-filter: blur(4px);
            background: #1f1a2ecc;
            cursor: pointer;
            box-shadow: 0 4px 8px #00000033;
            line-height: 1;
        }
        .icon-btn:active {
            transform: scale(0.90);
            background: #ffd96622;
        }
        .icon-btn.close-btn {
            color: #ffa79b;
            border-color: #ff6b5b55;
        }
        .icon-btn.close-btn:active {
            background: #ff5b4b33;
        }
        .icon-btn.minimize-btn {
            color: #b8d9ff;
            border-color: #6ba3ff55;
        }
        .icon-btn.minimize-btn:active {
            background: #4b8bff33;
        }
        .menu-grid {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin: 8px 0 6px;
        }
        .menu-row {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            background: #0f0c1a66;
            backdrop-filter: blur(6px);
            padding: 8px 16px 8px 20px;
            border-radius: 60px;
            border: 1px solid #ffd96633;
            box-shadow: inset 0 1px 2px #ffffff0a;
        }
        .menu-label {
            color: #ece4f0;
            font-weight: 600;
            font-size: 0.95rem;
            letter-spacing: 0.3px;
            text-shadow: 0 1px 4px #00000066;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .menu-label span {
            color: #fbc85a;
            margin-right: 4px;
        }
        .menu-btn-group {
            display: flex;
            gap: 8px;
        }
        .action-btn {
            background: #2c2340;
            border: 1px solid #ffd96655;
            color: #f5e8d4;
            padding: 6px 16px;
            border-radius: 40px;
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.4px;
            backdrop-filter: blur(4px);
            background: #1f1a2fcc;
            transition: 0.15s;
            cursor: pointer;
            box-shadow: 0 2px 6px #00000044;
            min-width: 70px;
            text-align: center;
        }
        .action-btn:active {
            transform: scale(0.92);
            background: #3d2f58;
        }
        .action-btn.primary {
            background: #d4a84b;
            border-color: #f7d78a;
            color: #1a1425;
            font-weight: 700;
            box-shadow: 0 0 12px #f7c45a55;
        }
        .action-btn.primary:active {
            background: #f0c45a;
        }
        .action-btn.secondary {
            background: #2a1f3b;
            border-color: #7f6b9a;
            color: #d5c4f0;
        }
        .server-row {
            margin-top: 6px;
            display: flex;
            justify-content: center;
        }
        .server-btn {
            background: #1b152b;
            border: 1px solid #ffd96655;
            padding: 8px 28px;
            border-radius: 60px;
            color: #e7d9ff;
            font-weight: 600;
            font-size: 0.9rem;
            letter-spacing: 1px;
            backdrop-filter: blur(4px);
            background: #1a1428cc;
            transition: 0.15s;
            cursor: pointer;
            width: 100%;
            text-align: center;
            box-shadow: 0 2px 8px #00000055;
        }
        .server-btn:active {
            transform: scale(0.94);
            background: #2f2148;
        }
        .chest-card.minimized {
            padding: 14px 18px;
            border-radius: 60px;
            background: #181325;
            border-color: #ffd96677;
        }
        .chest-card.minimized .menu-grid,
        .chest-card.minimized .server-row {
            display: none;
        }
        .chest-card.minimized .chest-header {
            margin-bottom: 0;
            border-bottom: none;
            padding-bottom: 0;
        }
        .chest-card.minimized .chest-title {
            font-size: 1.2rem;
        }
        .popup-overlay {
            position: fixed;
            inset: 0;
            background: #000000cc;
            backdrop-filter: blur(8px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 999;
            padding: 20px;
            animation: fadeIn 0.2s ease;
        }
        .popup-overlay.active {
            display: flex;
        }
        .popup-box {
            background: #1f1a2e;
            border-radius: 48px;
            padding: 32px 24px 28px;
            max-width: 340px;
            width: 100%;
            border: 1px solid #ffd96666;
            box-shadow: 0 30px 60px #000000cc;
            text-align: center;
            animation: slideUp 0.25s ease;
        }
        .popup-box p {
            color: #f5ecf0;
            font-size: 1.2rem;
            font-weight: 500;
            margin-bottom: 28px;
            letter-spacing: 0.3px;
            text-shadow: 0 1px 8px #00000088;
            line-height: 1.4;
        }
        .popup-box p small {
            display: block;
            font-weight: 300;
            font-size: 0.9rem;
            color: #b8a9d9;
            margin-top: 6px;
        }
        .popup-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
        }
        .popup-actions button {
            flex: 1;
            padding: 12px 0;
            border-radius: 60px;
            font-weight: 700;
            font-size: 1rem;
            border: none;
            cursor: pointer;
            transition: 0.15s;
            background: #2f2347;
            color: #e7d9ff;
            border: 1px solid #7f6b9a77;
        }
        .popup-actions button:active {
            transform: scale(0.92);
        }
        .popup-actions .btn-yes {
            background: #d4a84b;
            color: #1a1425;
            border-color: #f7d78a;
            font-weight: 800;
        }
        .popup-actions .btn-yes:active {
            background: #f0c45a;
        }
        .popup-actions .btn-no {
            background: #2f2347;
            color: #d5c4f0;
        }
        .popup-actions .btn-no:active {
            background: #3f2f5a;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px) scale(0.94); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .credit {
            text-align: center;
            color: #433b57;
            font-size: 0.6rem;
            letter-spacing: 0.5px;
            margin-top: 12px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <div class="drag-wrapper" id="dragWrapper">
        <div class="chest-card" id="chestCard">
            <div class="chest-content">
                <div class="chest-header">
                    <div class="chest-title">
                        KhDang-Auto-Chest <small>V1</small>
                    </div>
                    <div class="header-actions">
                        <button class="icon-btn minimize-btn" id="minimizeBtn">−</button>
                        <button class="icon-btn close-btn" id="closeBtn">✕</button>
                    </div>
                </div>
                <div class="menu-grid" id="menuGrid">
                    <div class="menu-row">
                        <span class="menu-label"><span>▶</span> BẮT ĐẦU FARM</span>
                        <div class="menu-btn-group">
                            <button class="action-btn primary" id="startFarmBtn">FARM</button>
                        </div>
                    </div>
                    <div class="menu-row">
                        <span class="menu-label"><span>⏸</span> DỤNG FARM</span>
                        <div class="menu-btn-group">
                            <button class="action-btn secondary" id="stopFarmBtn">DỪNG</button>
                        </div>
                    </div>
                </div>
                <div class="server-row">
                    <button class="server-btn" id="switchServerBtn">CHUYỂN SERVER</button>
                </div>
                <div class="credit">⚡ drag · anime edition</div>
            </div>
        </div>
    </div>
    <div class="popup-overlay" id="popupOverlay">
        <div class="popup-box">
            <p>
                Bạn có muốn tắt script Auto Chest?<br>
                <small>nhấn "Có" để tắt hoàn toàn</small>
            </p>
            <div class="popup-actions">
                <button class="btn-yes" id="popupYes">Có</button>
                <button class="btn-no" id="popupNo">Không (quay lại)</button>
            </div>
        </div>
    </div>
    <script>
        (function() {
            'use strict';
            var dragWrapper = document.getElementById('dragWrapper');
            var chestCard = document.getElementById('chestCard');
            var minimizeBtn = document.getElementById('minimizeBtn');
            var closeBtn = document.getElementById('closeBtn');
            var popupOverlay = document.getElementById('popupOverlay');
            var popupYes = document.getElementById('popupYes');
            var popupNo = document.getElementById('popupNo');
            var isMinimized = false;
            var posX = 0, posY = 0, startX = 0, startY = 0, isDragging = false;
            function onDragStart(e) {
                var touch = e.touches ? e.touches[0] : e;
                startX = touch.clientX - posX;
                startY = touch.clientY - posY;
                isDragging = true;
                dragWrapper.style.cursor = 'grabbing';
                e.preventDefault?.();
            }
            function onDragMove(e) {
                if (!isDragging) return;
                var touch = e.touches ? e.touches[0] : e;
                var newX = touch.clientX - startX;
                var newY = touch.clientY - startY;
                var rect = dragWrapper.getBoundingClientRect();
                var maxX = window.innerWidth - rect.width;
                var maxY = window.innerHeight - rect.height;
                newX = Math.min(Math.max(newX, 0), maxX);
                newY = Math.min(Math.max(newY, 0), maxY);
                posX = newX;
                posY = newY;
                dragWrapper.style.transform = 'translate(' + posX + 'px, ' + posY + 'px)';
                e.preventDefault?.();
            }
            function onDragEnd(e) {
                if (isDragging) {
                    isDragging = false;
                    dragWrapper.style.cursor = 'grab';
                }
            }
            dragWrapper.addEventListener('mousedown', onDragStart);
            document.addEventListener('mousemove', onDragMove);
            document.addEventListener('mouseup', onDragEnd);
            dragWrapper.addEventListener('touchstart', onDragStart, { passive: false });
            document.addEventListener('touchmove', onDragMove, { passive: false });
            document.addEventListener('touchend', onDragEnd);
            function toggleMinimize() {
                isMinimized = !isMinimized;
                chestCard.classList.toggle('minimized', isMinimized);
                minimizeBtn.textContent = isMinimized ? '+' : '−';
            }
            minimizeBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                toggleMinimize();
            });
            closeBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                popupOverlay.classList.add('active');
            });
            popupYes.addEventListener('click', function() {
                dragWrapper.style.display = 'none';
                popupOverlay.classList.remove('active');
            });
            popupNo.addEventListener('click', function() {
                popupOverlay.classList.remove('active');
            });
            popupOverlay.addEventListener('click', function(e) {
                if (e.target === popupOverlay) {
                    popupOverlay.classList.remove('active');
                }
            });
            document.getElementById('startFarmBtn').addEventListener('click', function() {
                alert('▶ BẮT ĐẦU FARM');
            });
            document.getElementById('stopFarmBtn').addEventListener('click', function() {
                alert('⏸ DỪNG FARM');
            });
            document.getElementById('switchServerBtn').addEventListener('click', function() {
                alert('🔄 CHUYỂN SERVER');
            });
            var rect = dragWrapper.getBoundingClientRect();
            posX = Math.max(0, (window.innerWidth - rect.width) / 2);
            posY = Math.max(0, (window.innerHeight - rect.height) / 2 - 20);
            dragWrapper.style.transform = 'translate(' + posX + 'px, ' + posY + 'px)';
            dragWrapper.style.cursor = 'grab';
            window.addEventListener('resize', function() {
                var rectNow = dragWrapper.getBoundingClientRect();
                var maxX = window.innerWidth - rectNow.width;
                var maxY = window.innerHeight - rectNow.height;
                posX = Math.min(Math.max(posX, 0), maxX);
                posY = Math.min(Math.max(posY, 0), maxY);
                dragWrapper.style.transform = 'translate(' + posX + 'px, ' + posY + 'px)';
            });
        })();
    </script>
</body>
</html>

let selectedChessFigure = null;

document.getElementById('startButton').addEventListener('click', () =>{
    startChessGame();
})

document.getElementById('colorThemeSelected').addEventListener('click', () =>{
    setColorTheme();
})


function startChessGame(){
    document.getElementById('startButton').style.display = 'none';

    document.getElementById('colorThemes').style.display = 'inline';

    spawnChessBoard();
    spawnChessFigures();
}

function spawnChessBoard() {
    const board = document.getElementById('chessBoard');
    board.style.display = 'grid';
    board.innerHTML = '';

    for (let i = 0; i < 8; ++i) {
        for (let j = 0; j < 8; ++j) {
            const square = document.createElement('div');
            square.className = (i + j) % 2 === 0 ? 'white square' : 'gray square';
            square.dataset.position = `${i}-${j}`;
            board.appendChild(square);
        }
    }
}

function spawnChessFigures() {
    const figures = {
        // Белые фигуры
        '0-0': '♖', '0-1': '♘', '0-2': '♗', '0-3': '♕', '0-4': '♔', '0-5': '♗', '0-6': '♘', '0-7': '♖',
        '1-0': '♙', '1-1': '♙', '1-2': '♙', '1-3': '♙', '1-4': '♙', '1-5': '♙', '1-6': '♙', '1-7': '♙',
        // Черные фигуры
        '7-0': '♜', '7-1': '♞', '7-2': '♝', '7-3': '♛', '7-4': '♚', '7-5': '♝', '7-6': '♞', '7-7': '♜',
        '6-0': '♟', '6-1': '♟', '6-2': '♟', '6-3': '♟', '6-4': '♟', '6-5': '♟', '6-6': '♟', '6-7': '♟'
    };

    const squares = document.querySelectorAll('.square');
	
    squares.forEach(square => {
        const position = square.dataset.position;
        if (figures[position]) {
            square.textContent = figures[position];
            square.addEventListener('click', handleSquareClick);
        }
    });
}

function SelectChessFigure(position) {
    if (selectedChessFigure) {
        UnLightCells();
        selectedChessFigure = null;
        return;
    }

    selectedChessFigure = position;

    fetch(`http://localhost:3000/api/moves?position=${position}`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    })
    .then((response) => {
        if (!response.ok) throw new Error("Сетевая ошибка: " + response.status);
        return response.json();
    })
    .then((moves) => {
        console.log("Успех: ", moves);
        LightCell(moves);
    })
    .catch((error) => {
        console.error("Ошибка: ", error);
        alert("Произошла ошибка при получении допустимых ходов");
    });
}

function LightCell(moves) {
    moves.forEach(move => {
        const square = document.querySelector(`.square[data-position="${move}"]`);
        console.log("SQUARE: " + move);
        if (square) {
            square.classList.add('choosen');

            // Создаем именованную функцию для обработки клика
            const handleClick = () => {
                moveChessFigure(selectedChessFigure, move);
                UnLightCells();
                selectedChessFigure = null;
            };

            // Удаляем обработчик события SelectChessFigure с подсвеченных клеток
            square.removeEventListener('click', handleSquareClick);
            square.addEventListener('click', handleClick);
            // Сохраняем ссылку на функцию непосредственно в элементе клетки
            square.originalHandleClick = handleClick; 
        }
    });
}


function UnLightCells() {
    const squares = document.querySelectorAll('.square');
    squares.forEach(square => {
        square.classList.remove('choosen');

        // Retrieve the function reference for removal
        const handleClick = square.originalHandleClick;
        if (handleClick) {
            square.removeEventListener('click', handleClick);
            delete square.originalHandleClick; // Clean up the reference
        }
    });
}

function setColorTheme() {
    const theme = document.getElementById('colorThemeSelected').value;
    const squares = document.querySelectorAll('.square');

    squares.forEach((square, index) => {
        if (theme === 'grayWhiteTheme') 
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'white square' : 'gray square';
        else if (theme === 'brownBeigeTheme') 
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'beige square' : 'brown square';
        else if (theme === 'yellowGreenTheme') 
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'yellow square' : 'green square';
        else if (theme === 'whitePurpleTheme') 
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'white square' : 'purple square';
    });
}

function moveChessFigure(from, to) {
    // Поиск исходной и конечной клетки
    console.log("FROM: " + from);
    console.log("TO: " + to);
    const fromSquare = document.querySelector(`.square[data-position="${from}"]`);
    const toSquare = document.querySelector(`.square[data-position="${to}"]`);

    if (!fromSquare || !toSquare) return;
	
	const figure = fromSquare.textContent;
	
	if (toSquare.textContent && (figure === toSquare.textContent)) return;

    fetch('http://localhost:3000/api/move', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            from: from,
            to: to,
        }),
    })
    .then(response => {
        if (!response.ok) throw new Error('Ошибка сети: ' + response.status);
        return response.json();
    })
    .then(data => {
        console.log('Успех:', data);
        // Записываем координаты клеток относительно устройства пользователя
        const rectFrom = fromSquare.getBoundingClientRect();
        const rectTo = toSquare.getBoundingClientRect();
        
        // Создание временного объекта для плавной анимации перемещения
        const temp = document.createElement('div');
        document.body.appendChild(temp);
        
        temp.textContent = figure;
        temp.className = 'chess-figure';
        
        temp.style.position = 'absolute';
        temp.style.left = `${rectFrom.left}px`;
        temp.style.top = `${rectFrom.top}px`;

        fromSquare.textContent = '';
        
        // Перемещение фигуры
        setTimeout(() => {
            temp.style.transition = 'transform 0.5s ease';
            temp.style.transform = `translate(${rectTo.left - rectFrom.left}px, ${rectTo.top - rectFrom.top}px)`;
        }, 10);
        
        // Обновление содержимого конечной клетки
        setTimeout(() => {
            toSquare.textContent = figure;
            document.body.removeChild(temp);
        }, 510);
        
        fromSquare.removeEventListener('click', handleSquareClick);		
        toSquare.addEventListener('click', handleSquareClick);
    })
    .catch(error => {
        console.error('Ошибка:', error);
        alert('Произошла ошибка при перемещении фигуры');
    });
}


function handleSquareClick(event) {
    const position = event.currentTarget.dataset.position;
    SelectChessFigure(position);
}
function status() {
   {
        printf alarm;
        for (i in arr){
        printf arr[i]
        }
        print ""
    }
};

function successStatus(x) {  # СИГНАЛИЗАЦИЯ
    if (x == "off") {
         if (alarm == 1) {
             alarm = 0
            {print "success: alarm disabled"} # сигнализация выключена
          } else { 
            {print "alarm error: already disabled"} # нельзя повторно снять с сигнализации
          }
    } else if (x == "on") {  # поставить на сигнализацию
       if (alarm == 0) {   
              numW = -1
              numC = -1
          for (i = 0; i < 10; i++) {
              if (arr[i] == windOpen) {  # проверка на открытые окна
                 numW = i 
                 break
              } else if (arr[i] == "["temp"]") {
                 numC = i 
                 break
              } else {
                 numW = -1
                 numC = -1
              }
          }
          if (numW >= 0) { # Если окно открыто
              {print "alarm error: window "(numW) " opened" } # выводит номера открытых окон
          } else if (numC >= 0) {
             {print "alarm error: cooler "(numC) " enabled" } # выводит номера включенного кондиционера
          } else {
              alarm = 1
              {print "success: alarm enabled"} # сигнализация включена
          } 
        } else if (alarm == 1) { 
             {print "alarm error: already enabled"} # нельзя повторно поставить на сигнализацию     
        } 
    } else {
        {print "error: unknown command"} # ошибка ввода
    }
}

function winStatus(num, stat) {  # Окна
    if (num < 0 || num > 9) { 
       {print "window error: room must be between 0 and 9"} # неправильный ввод диапазона номера комнаты
    } else {
        if (stat == "open") {  # Команда на открытие окна
            if (alarm == 0) {
                if ((num >= 0) && (num <= 9)) {
                    if (arr[num] == "["(temp)"]") {
                        {print "window error: cooler " (num) " enabled"}
                    } else  if (arr[num] == windOpen) {
                        {print "window error: " (num) " already opened"} # нельзя повторно открыть
                    } else {
                        arr[num] = windOpen
                        {print "success: window " (num) " opened"} # окно открыто
                    } 
                } else  if ((num < 0) || (num > 9)) {
                    {print "window error: room must be between 0 and 9"} # неправильный ввод диапазона номера комнаты 
                } else {
                    {print "error: unknown command"} # неправильный ввод команды
                }
            } else if (alarm == 1) {
                {print "window error: alarm enabled"} # нельзя открыть окно при включеной сигнализации
            } 
        } else if (stat == "close") {  # Команда на закрытие окна
            if (alarm == 1) {
                {print "window error: alarm enabled"} # нельзя  выполнять команды при включенной сигнализации
            } else if (alarm == 0) {
                if ((num >= 0) && (num <= 9)) {
                    if ((arr[num] == windRoom) || (arr[num] == "["(temp)"]")) {
                        {print "window error: " (num) " already closed"} # нельзя повторно закрыть
                    } else {
                        arr[num] = windRoom
                        {print "success: window " (num) " closed"}  # окно закрыто
                    } 
                } else  if (num < 0 || num > 9) {
                    {print "window error: room must be between 0 and 9"} # неправильный ввод диапазона номера комнаты 
                } else {
                    {print "error: unknown command"} # неправильны ввод
                }
            }
        } else {
            {print "error: unknown command"} # неправильны ввод
        }
    }
}

function coolStatus(num, tempC) {
    temp = tempC - "C"
    if (num >= 0 && num <= 9) {
        if (temp >= 18 && temp <= 26) { # Включение кондиционера
            if (alarm == 0) {  
                if (arr[num] != windOpen) {
                    arr[num] = "["temp"]"
                    {print "success: cooler " (num) " set to " (temp) }  # Кондиционер (№) включен на (температуру)
                } else if (arr[num] == windOpen) {
                    {print "cooler error: window " (num) " opened" } # выводит номера открытых окон
                } else {
                    {print "error: unknown command"} # ошибка ввода
                }  
            } else if (alarm == 1)  {
                {print "cooler error: alarm enabled" } # нельза на сигнализации включить кондиционер
            }          
        } else if (tempC == "off") {
            if (alarm == 1) {
                {print "cooler error: alarm enabled"} # нельзя выключить кондиционер при вкл сигнализации
            } else if (arr[num] == windRoom || arr[num] == windOpen ) {
                {print "cooler error: "(num)" already off"} # нельзя повторно выключить кондиционер
            } else if (arr[num] != windOpen && arr[num] != windRoom) {
                arr[num] = windRoom
                {print "success: cooler " (num)" disabled"}  # Кондиционер (№) выключен 
            }
        } else if (temp < 18 || temp > 26) {  # Если температура вне диапазона
            {print "cooler error: temp must be between 18 and 26"}  
        } else {
            {print "error: unknown command"} # ошибка ввода
        }
    } else if (num < 0 || num > 9) {        
        {print "cooler error: room must be between 0 and 9"}
    } else {
        {print "error: unknown command"} # ошибка ввода
    }
}

BEGIN{
    windOpen = "[\\/]";
    windRoom = "[  ]";
    alarm = 1;
    for (i= 0; i <= 9; i++){
        arr[i] = windRoom;
    }
}
  
/^$/{print $0; next}   
/^#/{print $0; next}
/^stat$/{status(); next}
/^alarm\s(on|off)$/{successStatus($2); next}
/^window\s[0-9]{1,}\s(open|close)$/{winStatus($2, $3); next}
/^cooler\s[0-9]{1,}\s((-?[0-9]{1,}C)|off)$/{coolStatus($2, $3); next}
/^\s*$/{print $0; next} 
/.*/{print "error: unknown command"} 

END{}
projeto = "Bem vindo ao Projeto Lighter Tracker DB"
print(projeto)

def function(parametro)
    while projeto != "Sair":
        print("Digite 'Sair' para encerrar o programa.")
        parametro = input("Digite um comando: ")
        if parametro == "Sair":
            print("Encerrando o programa...")
            break
        else:
            print(f"Você digitou: {parametro}")
## Gabriel Seixas
**Globo.com: coding challenge**

====================
#### Considerações Gerais
Você deverá usar este repositório como o repo principal do projeto, i.e.,
todos os seus commits devem estar registrados aqui, pois queremos ver como
você trabalha.

Esse problema tem algumas constraints:

a) Eu preciso conseguir rodar seu código em um Mac OS X OU no Ubuntu;

b) Devemos ser capazes de executar o seu código em uma VM ou máquina limpa com
   os seguintes comandos, ou algo similar:

    git clone seu-repositorio
    cd seu-repositorio
    ./configure (ou algo similar)
    make run (ou algo similar)

c) Devemos também conseguir rodar o seu código no nosso ambiente local;

Esses comandos devem ser o suficiente para configurar uma nova VM e rodar o
seu programa. Considere que o meu usuário não é root, porém tem permissão de
sudo. Podes considerar que temos instalado no meu sistema: Java, Python, Ruby
ou Go. Qualquer outra dependência que eu precisar você tem que prover.

O repositório contém algumas imagens de exemplo para implementação da parte
Web: uma com o desenho da tela e outra com um sprite de imagens que você
talvez deseje usar.

**Registre tudo**: testes que forem executados, idéias que gostaria de
implementar se tivesse tempo (explique como você as resolveria, se houvesse
tempo), decisões que forem tomadas e seus porquês, arquiteturas que forem
testadas, os motivos de terem sido modificadas ou abandonadas, instruções de
deploy e instalação, etc. Crie um único arquivo COMMENTS.md ou HISTORY.md no
repositório para isso.

=====================
#### O Problema

O problema que você deve resolver é o problema da votação do paredão do BBB em
versão WEB com HTML/CSS/Javascript + backend usando a linguagem de programação
e ferramentas open-source da sua preferência.

Nesse repositório você encontra algumas imagens necessárias para implementação
da parte web: uma com o desenho da tela e outra com um sprite de imagens que
você talvez deseje usar.

O paredão do BBB consiste em uma votação que confronta dois ou mais
integrantes do programa BBB, simulando o que acontece na realidade durante uma
temporada do BBB. A votação é apresentada em uma interface acessível pela WEB
onde os usuários optam por votar em uma das opções apresentadas. Eles não
precisam estar logados para conseguirem participar. Uma vez realizado o voto,
o usuário recebe uma tela com o comprovante do sucesso e um panorama percentual
dos votos por candidato até aquele momento.

============================
#### Regras de negócio

1. Os usuários podem votar quantas vezes quiserem, independente da opção
   escolhida. Entretanto, a produção do programa não quer receber votos
   oriundos de uma máquina, apenas votos de pessoas.

2. A votação é chamada na TV em horário nobre, com isso, é esperado um enorme
   volume de votos concentrados em um curto espaço de tempo. Esperamos ter um
   teste disso, e por razões práticas, podemos considerar 1000 votos/seg como 
   baseline de performance deste teste.

3. A produção do programa gostaria de ter URLs (a serem especificadas) para
   consultar: o total de geral votos, o total por participante e o total de
   votos por hora de cada paredão. Estas URLs precisam estar documentadas em
   algum lugar do projeto.

4. Além disso, os organizadores do BBB são exigentes. Portanto a interface do
   produto é algo bem importante. Organize seu tempo para que esse item também
   tenha a atenção mínima esperada.


===============================================
#### O que será avaliado na sua solução?

1. Seu código será observado por uma equipe de desenvolvedores que avaliarão a
   implementação do código, simplicidade e clareza da solução, a arquitetura,
   estilo de código, testes unitários, testes funcionais, nível de automação
   dos testes, o design da interface e a documentação.

2. Sua solução será submetida a uma bateria de testes de performance para
   garantir que atende a demanda de uma chamada em TV (performance e
   escalabilidade).

3. A automação da infra-estrutura também é importante. Imagine que você
   precisará fazer deploy do seu código em múltiplos servidores, então não é
   interessante ter que ficar entrando máquina por máquina para fazer o deploy
   da aplicação.

=============
#### Dicas

- Use ferramentas e bibliotecas open-source, mas documente as decisões e
  porquês;

- Automatize o máximo possível;

- Em caso de dúvidas, pergunte.

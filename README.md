# json2compound.ksh

![](https://github.com/takusuman/json2compound/assets/47103338/09013010-8fb8-4e72-a1a0-8355626a6f41)

Um desserializador de JSON para variáveis compostas de KornShell 93.

**For English speakers**: I wrote the README in Portuguese for a matter of
fatigue and somewhat some more liberty of expression in terms of playing around
with ideas. A translator will work pretty much flawlessly for this.

## Por quê?

Depois de [me quebrar com o meu desserializador de JSON do herbiec](https://github.com/takusuman/herbiec?tab=readme-ov-file#classifica%C3%A7%C3%A3o-final),
eu decidi que em algum momento deveria haver uma revanche que, senão do herbiec,
do desserializador de JSON para variável composta.  
Então, justamente no momento mais improvável de eu ter tempo para fazer algo
assim, eu decidi distrair minha mente com esse pequeno exercício.  

Acabou que o fiz para "me esquecer", mas poderia ter investido mais tempo
trabalhando em algumas partes que ainda estão pela metade no [sistema de montagem
do Copacabana Linux](https://github.com/Projeto-Pindorama/Copacabana.git).

### "Mas o Korn Shell já não tinha um desserializador de JSON?"

Bem, sim e não.  
Sim, foi implementado por volta de 2014, quando o KornShell 93 ainda estava de
baixo das asas da AT&T pelo pacote AST, entretanto, ele era extremamente
instável e, segundo um dos desenvolvedores, ``zazukai``, a funcionalidade ainda
não estava madura o suficiente. Inevitavelmente, dado ao andar da carruagem do
desenvolvimento do KornShell, [a funcionalidade foi
desabilitada](https://github.com/att/ast/issues/39#issuecomment-451868430),
logo esse projeto se mostrou necessário.
 
## Desempenho

### Seria justo comparar com a ``json.Unmarshall()`` de Google Go?

## Licença

Formalmente falando, está na licença ISC.  
Em outras palavras mais francas, use isso para o bem e como bem entender, só
saiba que eu ficaria feliz se citasse que veio daqui.  

Como é difícil encontrar programadores de KornShell nos dias atuais, restando
apenas alguns entusiastas da comunidade Illumos para ser genérico e alguns que
programam por necessidade por precisarem manter algum sistema legado, presumo
que você vá apenas estudar o algoritmo aqui apresentado. Bem, nesse caso, você
não seria obrigado nem sequer a citar a existência desse projeto, mas garanto
que eu pessoalmente ficaria grato.

### Posso copiar e colar no meu script?

Bem, esse algoritmo é elementar; mesmo se você tentasse escrever algo sozinho,
seria bem difícil que fosse distinto do meu código.  
Em suma, sim, pode.

## Similares
[Parser de INI do sistema de montagem do Copacabana](https://github.com/Projeto-Pindorama/copacabana/blob/copaclang/build-system/internals/helpers/helpers.shi#L51-L206)

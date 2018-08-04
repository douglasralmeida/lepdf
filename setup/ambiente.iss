; Script para o adicionar/remover endere�os no systempath

[Code]
const EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

procedure EnvAddPath(Path: string);
var
  Paths: string;
begin
  { Recebe o path atual (usa string vazia se n�o existir) }
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    Paths := '';
  
  { se a string j� existe no path, sai }
  if Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';') > 0 then
    exit;

  { Concatena a string no final da vari�vel path }
  Paths := Paths + ';'+ Path +';'

  { Substitui (ou cria se n�o houver) a vari�vel de ambiente path }
  if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    Log(Format('[%s] foi adicionado ao PATH do sistema: [%s]', [Path, Paths]))
  else
    Log(Format('Erro ao adicionar [%s] ao PATH do sitema: [%s]', [Path, Paths]));
end;

procedure EnvRemovePath(Path: string);
var
  Paths: string;
  P: Integer;
begin
  { Se a entrada do registro n�o existir, sai }
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    exit;

  { Se a string n�o for encontrada, sai }
  P := Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';');
  if P = 0 then
    exit;

  { Atualiza a vari�vel path }
  Delete(Paths, P - 1, Length(Path) + 1);

  { Substitui (ou cria se n�o houver) a vari�vel de ambiente path }
  if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    Log(Format('[%s] foi removido do PATH do sistema: [%s]', [Path, Paths]))
  else
    Log(Format('Erro ao remover [%s] do PATH do sistema: [%s]', [Path, Paths]));
end;
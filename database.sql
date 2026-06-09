-- ========================================================
-- BANCO DE DADOS PSIQUELINE
-- SISTEMA COMPLETO - ADMIN, PSICÓLOGO E PACIENTE
-- ========================================================

-- Criar banco de dados
CREATE DATABASE IF NOT EXISTS psiqueline;
USE psiqueline;

-- ========================================================
-- 1. TABELAS PRINCIPAIS
-- ========================================================

-- Tabela de usuários (base para todos)
CREATE TABLE IF NOT EXISTS usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    tipo ENUM('admin', 'psicologo', 'paciente') NOT NULL,
    status ENUM('ativo', 'inativo', 'pendente') DEFAULT 'pendente',
    ultimo_acesso DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_tipo (tipo)
);

-- Tabela de administradores
CREATE TABLE IF NOT EXISTS administradores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    perfil ENUM('Administrador', 'Super Admin') DEFAULT 'Administrador',
    permissoes JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_perfil (perfil)
);

-- Tabela de psicólogos
CREATE TABLE IF NOT EXISTS psicologos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    localizacao VARCHAR(100) NOT NULL,
    experiencia INT DEFAULT 0,
    preco_hora DECIMAL(10,2) NOT NULL,
    avaliacao DECIMAL(3,1) DEFAULT 0,
    total_avaliacoes INT DEFAULT 0,
    bio TEXT,
    formacao TEXT,
    atendimento_presencial BOOLEAN DEFAULT TRUE,
    atendimento_online BOOLEAN DEFAULT TRUE,
    atendimento_domicilio BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_especialidade (especialidade),
    INDEX idx_avaliacao (avaliacao)
);

-- Tabela de pacientes
CREATE TABLE IF NOT EXISTS pacientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    data_nascimento DATE,
    endereco VARCHAR(255),
    nacionalidade VARCHAR(50) DEFAULT 'Angolana',
    historico_medico TEXT,
    total_consultas INT DEFAULT 0,
    ultima_consulta DATE,
    proxima_consulta DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario_id (usuario_id)
);

-- ========================================================
-- 2. TABELAS DE CONSULTAS E AGENDA
-- ========================================================

-- Tabela de consultas
CREATE TABLE IF NOT EXISTS consultas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    psicologo_id INT NOT NULL,
    data_consulta DATE NOT NULL,
    horario TIME NOT NULL,
    tipo ENUM('presencial', 'video', 'domicilio') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('pendente', 'confirmada', 'realizada', 'cancelada') DEFAULT 'pendente',
    observacoes TEXT,
    link_video VARCHAR(255),
    endereco_domicilio VARCHAR(255),
    duracao_minutos INT DEFAULT 60,
    confirmada_em DATETIME,
    cancelada_em DATETIME,
    motivo_cancelamento VARCHAR(255),
    reagendamento_para INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    INDEX idx_paciente_id (paciente_id),
    INDEX idx_psicologo_id (psicologo_id),
    INDEX idx_data_consulta (data_consulta),
    INDEX idx_status (status)
);

-- Histórico de consultas
CREATE TABLE IF NOT EXISTS historico_consultas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    consulta_id INT NOT NULL,
    acao VARCHAR(50) NOT NULL,
    descricao TEXT,
    usuario_acao INT,
    data_acao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_acao) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_consulta_id (consulta_id)
);

-- Horários disponíveis dos psicólogos
CREATE TABLE IF NOT EXISTS horarios_disponiveis (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    dia_semana ENUM('segunda', 'terca', 'quarta', 'quinta', 'sexta', 'sabado', 'domingo') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    intervalo_minutos INT DEFAULT 60,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_horario (psicologo_id, dia_semana)
);

-- Bloqueios na agenda (férias, folgas)
CREATE TABLE IF NOT EXISTS bloqueios_agenda (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    tipo ENUM('ferias', 'folga', 'evento', 'formacao', 'outro') DEFAULT 'outro',
    descricao TEXT,
    recorrente BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE
);

-- ========================================================
-- 3. TABELAS DE AVALIAÇÕES
-- ========================================================

-- Avaliações dos psicólogos pelos pacientes
CREATE TABLE IF NOT EXISTS avaliacoes_psicologos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    paciente_id INT NOT NULL,
    consulta_id INT NOT NULL,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    recomendaria ENUM('sim', 'talvez', 'nao') DEFAULT 'sim',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_avaliacao (consulta_id, paciente_id)
);

-- ========================================================
-- 4. TABELAS FINANCEIRAS
-- ========================================================

-- Pagamentos dos pacientes
CREATE TABLE IF NOT EXISTS pagamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    consulta_id INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    metodo ENUM('multicaixa', 'transferencia', 'dinheiro', 'cartao') NOT NULL,
    status ENUM('pendente', 'pago', 'cancelado', 'estornado') DEFAULT 'pendente',
    data_pagamento DATE,
    comprovativo_url VARCHAR(500),
    referencia_transacao VARCHAR(100),
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE CASCADE
);

-- Recibos de pagamento
CREATE TABLE IF NOT EXISTS recibos_pagamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pagamento_id INT NOT NULL,
    numero_recibo VARCHAR(50) UNIQUE NOT NULL,
    data_emissao DATE NOT NULL,
    pdf_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pagamento_id) REFERENCES pagamentos(id) ON DELETE CASCADE
);

-- Solicitações de comissão (psicólogos)
CREATE TABLE IF NOT EXISTS solicitacoes_comissao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    periodo_referencia VARCHAR(20),
    data_envio DATE NOT NULL,
    valor_consulta DECIMAL(10,2) NOT NULL,
    valor_comissao DECIMAL(10,2) GENERATED ALWAYS AS (valor_consulta * 0.1) STORED,
    comprovativo_url VARCHAR(500),
    status ENUM('pendente', 'aprovado', 'rejeitado') DEFAULT 'pendente',
    observacao TEXT,
    data_analise DATETIME,
    analisado_por INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    FOREIGN KEY (analisado_por) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Dados bancários dos psicólogos
CREATE TABLE IF NOT EXISTS dados_bancarios_psicologo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    banco VARCHAR(100) NOT NULL,
    numero_conta VARCHAR(50) NOT NULL,
    iban VARCHAR(50),
    titular VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_psicologo (psicologo_id)
);

-- Transações financeiras
CREATE TABLE IF NOT EXISTS transacoes_financeiras (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    consulta_id INT,
    tipo ENUM('recebimento', 'comissao', 'saque', 'estorno') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('pendente', 'confirmado', 'cancelado') DEFAULT 'pendente',
    data_transacao DATE NOT NULL,
    descricao VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE SET NULL
);

-- ========================================================
-- 5. TABELAS DE PROGRESSO E METAS
-- ========================================================

-- Avaliações de progresso do paciente
CREATE TABLE IF NOT EXISTS avaliacoes_progresso (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    psicologo_id INT NOT NULL,
    data_avaliacao DATE NOT NULL,
    bem_estar INT CHECK (bem_estar BETWEEN 0 AND 100),
    ansiedade INT CHECK (ansiedade BETWEEN 0 AND 100),
    depressao INT CHECK (depressao BETWEEN 0 AND 100),
    estresse INT CHECK (estresse BETWEEN 0 AND 100),
    qualidade_sono INT CHECK (qualidade_sono BETWEEN 0 AND 100),
    autoconfianca INT CHECK (autoconfianca BETWEEN 0 AND 100),
    motivacao INT CHECK (motivacao BETWEEN 0 AND 100),
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE
);

-- Metas dos pacientes
CREATE TABLE IF NOT EXISTS metas_paciente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    psicologo_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    tipo ENUM('ansiedade', 'autoestima', 'sono', 'exercicio', 'meditacao', 'leitura', 'social', 'outro') DEFAULT 'outro',
    meta_valor INT DEFAULT 100,
    progresso_atual INT DEFAULT 0,
    status ENUM('pendente', 'em_andamento', 'concluida', 'cancelada') DEFAULT 'pendente',
    data_inicio DATE NOT NULL,
    data_limite DATE,
    data_conclusao DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE
);

-- Marcos de progresso (conquistas)
CREATE TABLE IF NOT EXISTS marco_progresso (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    data_marco DATE NOT NULL,
    tipo ENUM('primeira_consulta', 'melhora_significativa', 'meta_alcancada', 'alta', 'outro') DEFAULT 'outro',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE
);

-- ========================================================
-- 6. TABELAS DE NOTIFICAÇÕES
-- ========================================================

-- Notificações da agenda
CREATE TABLE IF NOT EXISTS notificacoes_agenda (
    id INT PRIMARY KEY AUTO_INCREMENT,
    consulta_id INT,
    psicologo_id INT,
    paciente_id INT,
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT,
    tipo ENUM('lembrete', 'confirmacao', 'cancelamento', 'reagendamento') DEFAULT 'lembrete',
    lida BOOLEAN DEFAULT FALSE,
    data_envio DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id) ON DELETE SET NULL,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE SET NULL,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE SET NULL
);

-- Notificações do sistema
CREATE TABLE IF NOT EXISTS notificacoes_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    titulo VARCHAR(200),
    mensagem TEXT,
    tipo ENUM('info', 'success', 'warning', 'error') DEFAULT 'info',
    lida BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ========================================================
-- 7. TABELAS DE FAVORITOS E INTERAÇÕES
-- ========================================================

-- Favoritos (pacientes salvam psicólogos)
CREATE TABLE IF NOT EXISTS favoritos_psicologos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    psicologo_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_favorito (paciente_id, psicologo_id)
);

-- Visualizações de perfil de psicólogo
CREATE TABLE IF NOT EXISTS visualizacoes_psicologo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    paciente_id INT,
    ip VARCHAR(45),
    data_visualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE SET NULL
);

-- ========================================================
-- 8. TABELAS DE LOGS E CONFIGURAÇÕES
-- ========================================================

-- Logs de usuários
CREATE TABLE IF NOT EXISTS logs_usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    acao VARCHAR(100),
    ip VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Configurações do sistema
CREATE TABLE IF NOT EXISTS configuracoes_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    chave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT,
    descricao VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Configurações de comissão
CREATE TABLE IF NOT EXISTS config_comissoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    percentual_comissao DECIMAL(5,2) DEFAULT 10.00,
    prazo_maximo_envio INT DEFAULT 30,
    prazo_pagamento INT DEFAULT 15,
    valor_minimo_saque DECIMAL(10,2) DEFAULT 5000.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========================================================
-- 9. RELACIONAMENTO PACIENTE-PSICÓLOGO
-- ========================================================

-- Relacionamento entre paciente e psicólogo (quem atende quem)
CREATE TABLE IF NOT EXISTS paciente_psicologo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    psicologo_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    status ENUM('ativo', 'concluido', 'transferido') DEFAULT 'ativo',
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
    FOREIGN KEY (psicologo_id) REFERENCES psicologos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_relacionamento (paciente_id, psicologo_id)
);

-- ========================================================
-- 10. INSERTS DE DADOS INICIAIS
-- ========================================================

-- Configurações padrão
INSERT INTO configuracoes_sistema (chave, valor, descricao) VALUES
('comissao_percentual', '10', 'Percentual de comissão da plataforma'),
('horario_inicio', '08:00', 'Horário de início da plataforma'),
('horario_fim', '20:00', 'Horário de término da plataforma'),
('metodos_pagamento', '["multicaixa","transferencia","dinheiro"]', 'Métodos de pagamento aceitos');

INSERT INTO config_comissoes (percentual_comissao, prazo_maximo_envio, prazo_pagamento, valor_minimo_saque) VALUES
(10.00, 30, 15, 5000.00);

-- Usuário administrador padrão
INSERT INTO usuarios (nome, email, senha, telefone, tipo, status) VALUES
('Ana Rodrigues', 'ana.rodrigues@psiqueline.ao', '$2y$10$hash_aqui', '+244 923 456 789', 'admin', 'ativo');

INSERT INTO administradores (usuario_id, perfil) VALUES (1, 'Super Admin');

-- ========================================================
-- 11. VIEWS ÚTEIS
-- ========================================================

-- View para listar administradores
CREATE VIEW vw_administradores AS
SELECT a.id, u.nome, u.email, u.telefone, a.perfil, u.status, u.ultimo_acesso
FROM administradores a JOIN usuarios u ON a.usuario_id = u.id;

-- View para listar psicólogos completos
CREATE VIEW vw_psicologos_completo AS
SELECT p.id, u.nome, u.email, u.telefone, u.status, p.especialidade, p.localizacao,
       p.experiencia, p.preco_hora, p.avaliacao, p.total_avaliacoes, p.bio, p.formacao
FROM psicologos p JOIN usuarios u ON p.usuario_id = u.id;

-- View para listar pacientes completos
CREATE VIEW vw_pacientes_completo AS
SELECT p.id, u.nome, u.email, u.telefone, u.status, p.data_nascimento, p.endereco,
       p.nacionalidade, p.total_consultas, p.ultima_consulta
FROM pacientes p JOIN usuarios u ON p.usuario_id = u.id;

-- View para consultas com detalhes
CREATE VIEW vw_consultas_completo AS
SELECT c.*, 
       (SELECT nome FROM usuarios u JOIN pacientes p ON u.id = p.usuario_id WHERE p.id = c.paciente_id) as paciente_nome,
       (SELECT nome FROM usuarios u JOIN psicologos ps ON u.id = ps.usuario_id WHERE ps.id = c.psicologo_id) as psicologo_nome
FROM consultas c;

-- ========================================================
-- 12. ÍNDICES ADICIONAIS PARA PERFORMANCE
-- ========================================================

CREATE INDEX idx_usuarios_nome ON usuarios(nome);
CREATE INDEX idx_consultas_data ON consultas(data_consulta);
CREATE INDEX idx_pagamentos_status ON pagamentos(status);
CREATE INDEX idx_notificacoes_lida ON notificacoes_agenda(lida);
CREATE INDEX idx_solicitacoes_comissao_status ON solicitacoes_comissao(status);
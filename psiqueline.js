/* ==========================================================
   PSIQUELINE – JAVASCRIPT COMPLETO
   Contém:
   1. Dados dos 6 psicólogos fictícios
   2. Lógica de abrir/fechar modais
   3. Lógica do agendamento de consulta
   4. Menu hamburguer (mobile)
   5. Lógica da página de login
========================================================== */

/* ----------------------------------------------------------
   SECÇÃO 1 – BASE DE DADOS DOS PSICÓLOGOS
   Cada objeto contém todas as informações do profissional.
   Para adicionar ou editar um psicólogo, modifique aqui.
---------------------------------------------------------- */
const psicologos = {

  /* ========================================================
     PSICÓLOGO 1 – Dr. António Sebastião
  ======================================================== */
  psi1: {
    id: 'psi1',
    nome: 'Dr. António Sebastião',
    titulo: 'Psicólogo Clínico',
    area: 'Distúrbios Mentais · Ansiedade · Depressão',
    avaliacao: '4.9',
    totalAvaliacoes: 87,
    anos: 12,
    clientes: '+230 clientes satisfeitos',
    localizacao: 'Talatona, Belas – Luanda',
    foto: 'imagens/psi1.jpg',
    // ← Coloque o ficheiro aqui
    iniciais: 'AS',

    /* Informações Pessoais */
    pessoal: {
      dataNascimento: '15 de Março de 1981',
      naturalidade: 'Luanda, Angola',
      idiomas: 'Português, Inglês, Kimbundu',
      estadoCivil: 'Casado, 2 filhos',
      hobbies: 'Leitura, música clássica, corrida matinal'
    },

    /* Formação Académica */
    formacao: [{
      grau: 'Licenciatura em Psicologia Clínica',
      instituicao: 'Universidade Agostinho Neto (UAN)',
      ano: '2005'
    },
      {
        grau: 'Pós-Graduação em Psicoterapia Cognitivo-Comportamental',
        instituicao: 'Universidade Lusíada de Angola',
        ano: '2008'
      },
      {
        grau: 'Certificação em Neuropsicologia',
        instituicao: 'Universidade Católica de Angola (UCAN)',
        ano: '2013'
      }],

    /* Experiência Profissional */
    experiencia: [{
      cargo: 'Psicólogo Clínico Sénior',
      local: 'Clínica Esperança – Luanda',
      periodo: '2013 – Presente'
    },
      {
        cargo: 'Psicólogo Residente',
        local: 'Hospital Militar Principal de Luanda',
        periodo: '2009 – 2013'
      },
      {
        cargo: 'Psicólogo Voluntário',
        local: 'ONG Mente Sã – Luanda',
        periodo: '2006 – 2009'
      }],

    /* Especialidades */
    especialidades: [
      'Transtorno de Ansiedade Generalizada',
      'Depressão Maior e Distimia',
      'Transtorno Obsessivo-Compulsivo (TOC)',
      'Síndrome de Burnout',
      'Terapia Cognitivo-Comportamental (TCC)'
    ],

    /* Bio resumida para o modal */
    bio: 'Com mais de 12 anos de experiência em psicologia clínica, o Dr. António Sebastião é especialista no tratamento de distúrbios mentais, com foco em ansiedade e depressão. A sua abordagem humanista e centrada no cliente garante um ambiente seguro e de confiança para o processo terapêutico.',

    /* Valores por hora em Kwanzas */
    precoBase: 8500,
    disponibilidade: 'Segunda a Sexta'
  },

  /* ========================================================
     PSICÓLOGO 2 – Dra. Marlene Teixeira
  ======================================================== */
  psi2: {
    id: 'psi2',
    nome: 'Dra. Marlene Teixeira',
    titulo: 'Psicóloga Clínica e Organizacional',
    area: 'Autoestima · Liderança Feminina · Empoderamento',
    avaliacao: '4.8',
    totalAvaliacoes: 64,
    anos: 8,
    clientes: '+180 clientes satisfeitos',
    localizacao: 'Mutamba, Largo do Ambiente – Luanda',
    foto: 'imagens/psi2.jpg',
    // ← Coloque o ficheiro aqui
    iniciais: 'MT',

    pessoal: {
      dataNascimento: '22 de Junho de 1988',
      naturalidade: 'Benguela, Angola',
      idiomas: 'Português, Inglês, Francês',
      estadoCivil: 'Solteira',
      hobbies: 'Yoga, escrita criativa, viagens'
    },

    formacao: [{
      grau: 'Licenciatura em Psicologia',
      instituicao: 'Universidade Agostinho Neto (UAN)',
      ano: '2011'
    },
      {
        grau: 'Mestrado em Psicologia Organizacional',
        instituicao: 'Universidade Lusíada de Angola',
        ano: '2014'
      },
      {
        grau: 'Certificação em Coaching de Liderança',
        instituicao: 'Instituto Superior de Ciências da Educação (ISCED)',
        ano: '2017'
      }],

    experiencia: [{
      cargo: 'Psicóloga e Coach de Liderança',
      local: 'Consultório Próprio – Mutamba',
      periodo: '2017 – Presente'
    },
      {
        cargo: 'Psicóloga Organizacional',
        local: 'Banco de Fomento Angola (BFA)',
        periodo: '2014 – 2017'
      },
      {
        cargo: 'Psicóloga Estagiária',
        local: 'Centro de Saúde Mental de Luanda',
        periodo: '2011 – 2014'
      }],

    especialidades: [
      'Desenvolvimento da Autoestima e Autoconfiança',
      'Liderança Feminina e Empoderamento',
      'Coaching Profissional e de Vida',
      'Gestão do Stress e Ansiedade Social',
      'Orientação Vocacional e de Carreira'
    ],

    bio: 'A Dra. Marlene Teixeira combina a psicologia clínica com o coaching de liderança para ajudar as suas clientes a descobrirem o seu potencial máximo. Especialista em empoderamento feminino, já transformou a vida de centenas de mulheres em Luanda, ajudando-as a superar bloqueios emocionais e a assumir papéis de liderança.',

    precoBase: 7500,
    disponibilidade: 'Segunda a Sábado'
  },

  /* ========================================================
     PSICÓLOGO 3 – Dr. Carlos Domingos
  ======================================================== */
  psi3: {
    id: 'psi3',
    nome: 'Dr. Carlos Domingos',
    titulo: 'Psicólogo Clínico e do Trabalho',
    area: 'Burnout Profissional · Stress · Psicologia do Trabalho',
    avaliacao: '4.7',
    totalAvaliacoes: 102,
    anos: 15,
    clientes: '+310 clientes satisfeitos',
    localizacao: 'Vila-Alice – Luanda',
    foto: 'imagens/psi3.jpg',
    // ← Coloque o ficheiro aqui
    iniciais: 'CD',

    pessoal: {
      dataNascimento: '08 de Novembro de 1977',
      naturalidade: 'Huambo, Angola',
      idiomas: 'Português, Espanhol, Umbundu',
      estadoCivil: 'Casado, 3 filhos',
      hobbies: 'Futebol, jardinagem, leitura de filosofia'
    },

    formacao: [{
      grau: 'Licenciatura em Psicologia Clínica',
      instituicao: 'Universidade Agostinho Neto (UAN)',
      ano: '2001'
    },
      {
        grau: 'Pós-Graduação em Psicologia do Trabalho e das Organizações',
        instituicao: 'Universidade Católica de Angola (UCAN)',
        ano: '2005'
      },
      {
        grau: 'Especialização em Prevenção de Riscos Psicossociais',
        instituicao: 'Universidade Lusíada de Angola',
        ano: '2010'
      }],

    experiencia: [{
      cargo: 'Psicólogo Clínico Especialista',
      local: 'Clínica São Lucas – Vila-Alice',
      periodo: '2010 – Presente'
    },
      {
        cargo: 'Psicólogo do Trabalho',
        local: 'Sonangol – Recursos Humanos',
        periodo: '2005 – 2010'
      },
      {
        cargo: 'Psicólogo Clínico',
        local: 'Hospital Américo Boavida – Luanda',
        periodo: '2001 – 2005'
      }],

    especialidades: [
      'Burnout e Esgotamento Profissional',
      'Stress no Local de Trabalho',
      'Gestão de Conflitos Organizacionais',
      'Psicologia Positiva e Resiliência',
      'Reabilitação Psicossocial'
    ],

    bio: 'Com 15 anos de experiência, o Dr. Carlos Domingos é uma referência em psicologia do trabalho em Angola. A sua passagem pela Sonangol deu-lhe uma compreensão única das pressões do ambiente corporativo angolano. Especialista em burnout, já ajudou centenas de profissionais a recuperar o equilíbrio e a qualidade de vida.',

    precoBase: 9000,
    disponibilidade: 'Segunda a Sexta'
  },

  /* ========================================================
     PSICÓLOGO 4 – Dra. Joana Ferreira
  ======================================================== */
  psi4: {
    id: 'psi4',
    nome: 'Dra. Joana Ferreira',
    titulo: 'Psicóloga Infantil e Familiar',
    area: 'Psicologia Infantil · Família · Parentalidade',
    avaliacao: '5.0',
    totalAvaliacoes: 43,
    anos: 10,
    clientes: '+95 clientes satisfeitos',
    localizacao: 'Rangel, C9 – Luanda',
    foto: 'imagens/psi4.jpg',
    // ← Coloque o ficheiro aqui
    iniciais: 'JF',

    pessoal: {
      dataNascimento: '30 de Janeiro de 1985',
      naturalidade: 'Luanda, Angola',
      idiomas: 'Português, Inglês',
      estadoCivil: 'Casada, 1 filha',
      hobbies: 'Pintura, teatro infantil, culinária'
    },

    formacao: [{
      grau: 'Licenciatura em Psicologia',
      instituicao: 'Universidade Agostinho Neto (UAN)',
      ano: '2008'
    },
      {
        grau: 'Especialização em Psicologia Infantil e do Desenvolvimento',
        instituicao: 'Instituto Superior de Ciências da Educação (ISCED)',
        ano: '2011'
      },
      {
        grau: 'Certificação em Terapia Lúdica (Play Therapy)',
        instituicao: 'Universidade Lusíada de Angola',
        ano: '2015'
      }],

    experiencia: [{
      cargo: 'Psicóloga Infantil e Familiar',
      local: 'Consultório Pais e Filhos – Rangel',
      periodo: '2015 – Presente'
    },
      {
        cargo: 'Psicóloga Escolar',
        local: 'Colégio Internacional de Luanda',
        periodo: '2011 – 2015'
      },
      {
        cargo: 'Psicóloga Infantil',
        local: 'Centro Pediátrico David Bernardino',
        periodo: '2008 – 2011'
      }],

    especialidades: [
      'Desenvolvimento Infantil (0–12 anos)',
      'Terapia Lúdica e Expressiva',
      'Dificuldades de Aprendizagem e TDAH',
      'Mediação Familiar e Parentalidade Positiva',
      'Gestão Emocional em Crianças e Adolescentes'
    ],

    bio: 'A Dra. Joana Ferreira é a única psicóloga da PsiqueLine com avaliação perfeita de 5.0 estrelas. Especialista em crianças e famílias, utiliza técnicas lúdicas e criativas para trabalhar com os mais jovens. A sua dedicação à parentalidade positiva ajuda pais e filhos a construírem relações mais saudáveis e felizes.',

    precoBase: 7000,
    disponibilidade: 'Terça a Sábado'
  },

  /* ========================================================
     PSICÓLOGO 5 – Dr. Miguel Nzinga
  ======================================================== */
  psi5: {
    id: 'psi5',
    nome: 'Dr. Miguel Nzinga',
    titulo: 'Psicólogo e Especialista em Comunicação',
    area: 'Medo de Falar em Público · Oratória · Comunicação',
    avaliacao: '4.6',
    totalAvaliacoes: 55,
    anos: 6,
    clientes: '+120 clientes satisfeitos',
    localizacao: 'Mutamba, Largo do Ambiente – Luanda',
    foto: 'imagens/psi5.jpg',
    // ← Coloque o ficheiro aqui
    iniciais: 'MN',

    pessoal: {
      dataNascimento: '14 de Agosto de 1991',
      naturalidade: 'Malanje, Angola',
      idiomas: 'Português, Inglês, Kimbundu',
      estadoCivil: 'Solteiro',
      hobbies: 'Debate público, teatro, ciclismo'
    },

    formacao: [{
      grau: 'Licenciatura em Psicologia',
      instituicao: 'Universidade Agostinho Neto (UAN)',
      ano: '2014'
    },
      {
        grau: 'Pós-Graduação em Psicologia da Comunicação',
        instituicao: 'Universidade Católica de Angola (UCAN)',
        ano: '2017'
      },
      {
        grau: 'Certificação em Oratória e Comunicação Não-Verbal',
        instituicao: 'Instituto Superior de Comunicação Social de Angola',
        ano: '2018'
      }],

    experiencia: [{
      cargo: 'Psicólogo e Coach de Comunicação',
      local: 'Academia de Oratória Luanda',
      periodo: '2018 – Presente'
    },
      {
        cargo: 'Psicólogo e Formador',
        local: 'Centro de Formação Profissional de Luanda',
        periodo: '2016 – 2018'
      },
      {
        cargo: 'Psicólogo Clínico Junior',
        local: 'Clínica Nova Vida – Luanda',
        periodo: '2014 – 2016'
      }],

    especialidades: [
      'Glossofobia (Medo de Falar em Público)',
      'Técnicas de Oratória e Discurso',
      'Comunicação Assertiva e Não-Verbal',
      'Confiança e Presença em Público',
      'Preparação para Apresentações e Defesas'
    ],

    bio: 'O Dr. Miguel Nzinga transformou o seu próprio percurso – de uma pessoa com fobia social severa a um especialista em comunicação pública – numa metodologia única que já ajudou mais de 120 pessoas. O mais jovem da equipa PsiqueLine, a sua energia e abordagem prática tornam cada sessão numa experiência transformadora.',

    precoBase: 6500,
    disponibilidade: 'Segunda a Sábado'
  },

  /* ========================================================
     PSICÓLOGO 6 – Dra. Sandra Lopes
  ======================================================== */
  psi6: {
    id: 'psi6',
    nome: 'Dra. Sandra Lopes',
    titulo: 'Psicóloga Clínica e Terapeuta de Casal',
    area: 'Relacionamentos · Terapia de Casal · Conflitos Familiares',
    avaliacao: '4.8',
    totalAvaliacoes: 78,
    anos: 9,
    clientes: '+200 clientes satisfeitos',
    localizacao: 'Talatona, Belas – Luanda',
    foto: 'imagens/psi6.jpg',
    // ← Coloque o ficheiro aqui
    iniciais: 'SL',

    pessoal: {
      dataNascimento: '05 de Abril de 1986',
      naturalidade: 'Cabinda, Angola',
      idiomas: 'Português, Francês, Lingala',
      estadoCivil: 'Casada, 2 filhos',
      hobbies: 'Música, dança, voluntariado'
    },

    formacao: [{
      grau: 'Licenciatura em Psicologia Clínica',
      instituicao: 'Universidade Agostinho Neto (UAN)',
      ano: '2009'
    },
      {
        grau: 'Mestrado em Terapia Sistémica e Familiar',
        instituicao: 'Universidade Lusíada de Angola',
        ano: '2012'
      },
      {
        grau: 'Especialização em Mediação de Conflitos',
        instituicao: 'Universidade Católica de Angola (UCAN)',
        ano: '2016'
      }],

    experiencia: [{
      cargo: 'Psicóloga e Terapeuta de Casal',
      local: 'Consultório Harmonia – Talatona',
      periodo: '2016 – Presente'
    },
      {
        cargo: 'Psicóloga Clínica',
        local: 'Hospital Geral de Luanda',
        periodo: '2012 – 2016'
      },
      {
        cargo: 'Psicóloga Voluntária',
        local: 'Cruz Vermelha Angolana',
        periodo: '2009 – 2012'
      }],

    especialidades: [
      'Terapia de Casal e Conflitos Conjugais',
      'Mediação Familiar e Divórcio Consciente',
      'Perda, Luto e Transições de Vida',
      'Dependências Emocionais e Relacionamentos Tóxicos',
      'Comunicação Não-Violenta em Família'
    ],

    bio: 'A Dra. Sandra Lopes acredita que relações saudáveis são a base de uma vida plena. Com 9 anos de experiência em terapia de casal e família, já ajudou mais de 200 pessoas a reconstruir laços e a comunicar com amor e respeito. A sua abordagem sistémica considera a família como um sistema vivo que pode sempre encontrar novo equilíbrio.',

    precoBase: 8000,
    disponibilidade: 'Segunda a Sexta'
  }
};

/* ----------------------------------------------------------
   SECÇÃO 2 – CONFIGURAÇÃO DAS CONSULTAS

   Tipos de consulta disponíveis
   Durações com multiplicador de preço
   Períodos do dia
   Dias da semana
---------------------------------------------------------- */

/* Tipos de consulta e o seu multiplicador de preço */
const tiposConsulta = [{
  id: 'video',
  label: 'Videochamada',
  icone: 'fa-video',
  multiplicador: 1.0
},
  {
    id: 'domicilio',
    label: 'Ao Domicílio',
    icone: 'fa-house',
    multiplicador: 1.4
  },
  {
    id: 'presencial',
    label: 'Consulta Normal',
    icone: 'fa-building',
    multiplicador: 1.0
  }];

/* Durações disponíveis */
const duracoes = [{
  horas: 1,
  label: '1h',
  multiplicador: 1.0
},
  {
    horas: 2,
    label: '2h',
    multiplicador: 1.9
  },
  {
    horas: 3,
    label: '3h',
    multiplicador: 2.7
  },
  {
    horas: 4,
    label: '4h',
    multiplicador: 3.4
  },
  {
    horas: 5,
    label: '5h',
    multiplicador: 4.0
  }];

/* Períodos do dia */
const periodos = ['Manhã', 'Tarde', 'Noite'];

/* Dias da semana (abreviados) */
const diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

/* Estado da consulta que o utilizador está a configurar */
let selecao = {
  psicologo: null,
  // objeto do psicólogo selecionado
  tipo: null,
  // tipo de consulta
  duracao: null,
  // objeto de duração
  periodo: null,
  // período do dia
  dia: null // dia da semana
};

/* ----------------------------------------------------------
   SECÇÃO 3 – FUNÇÕES DO MODAL DE PERFIL DO PSICÓLOGO
---------------------------------------------------------- */

/**
* abrirPerfil(id)
* Chamada ao clicar num card de psicólogo.
* Preenche o modal com os dados do psicólogo e abre-o.
*/
function abrirPerfil(id) {
  const psi = psicologos[id]; // Busca os dados do psicólogo
  if (!psi) return;

  selecao.psicologo = psi; // Guarda o psicólogo atual

  /* Constrói o HTML interno do modal */
  const html = `
  <!-- Topo colorido com foto e nome -->
  <div class="modal-perfil-topo">
  <div class="modal-foto">
  <img src="${psi.foto}" alt="${psi.nome}" onerror="this.style.display='none'" />
  <span class="modal-foto-iniciais">${psi.iniciais}</span>
  </div>
  <div>
  <h2 class="modal-nome">${psi.nome}</h2>
  <p class="modal-area">${psi.titulo}</p>
  <div class="modal-avaliacao">
  <i class="fa fa-star"></i>
  <span>${psi.avaliacao} (${psi.totalAvaliacoes} avaliações)</span>
  </div>
  </div>
  </div>

  <!-- Corpo com abas de informação -->
  <div class="modal-corpo">

  <!-- Abas de navegação -->
  <div class="modal-abas">
  <button class="modal-aba-btn ativa" onclick="trocarAbaModal('sobre', this)">Sobre</button>
  <button class="modal-aba-btn" onclick="trocarAbaModal('formacao', this)">Formação</button>
  <button class="modal-aba-btn" onclick="trocarAbaModal('experiencia', this)">Experiência</button>
  <button class="modal-aba-btn" onclick="trocarAbaModal('pessoal', this)">Pessoal</button>
  </div>

  <!-- ABA: Sobre -->
  <div class="modal-aba-conteudo ativa" id="aba-sobre">
  <p style="line-height:1.7; color:#444; margin-bottom:1.2rem;">${psi.bio}</p>

  <div class="info-linha">
  <i class="fa fa-map-marker-alt"></i>
  <span><strong>Localização:</strong> ${psi.localizacao}</span>
  </div>
  <div class="info-linha">
  <i class="fa fa-clock"></i>
  <span><strong>Experiência:</strong> ${psi.anos} anos</span>
  </div>
  <div class="info-linha">
  <i class="fa fa-users"></i>
  <span><strong>Clientes:</strong> ${psi.clientes}</span>
  </div>
  <div class="info-linha">
  <i class="fa fa-calendar"></i>
  <span><strong>Disponibilidade:</strong> ${psi.disponibilidade}</span>
  </div>
  <div class="info-linha">
  <i class="fa fa-money-bill"></i>
  <span><strong>Preço base:</strong> ${psi.precoBase.toLocaleString('pt-AO')} KZ / hora</span>
  </div>

  <!-- Especialidades listadas como tags -->
  <p style="font-weight:700; color:var(--azul-escuro); margin: 1rem 0 0.5rem;">Especialidades:</p>
  <div style="display:flex; flex-wrap:wrap; gap:0.4rem;">
  ${psi.especialidades.map(e => `<span style="background:var(--azul-claro); color:var(--azul-escuro); padding:0.3rem 0.8rem; border-radius:20px; font-size:0.8rem; font-weight:600;">${e}</span>`).join('')}
  </div>
  </div>

  <!-- ABA: Formação Académica -->
  <div class="modal-aba-conteudo" id="aba-formacao">
  ${psi.formacao.map(f => `
    <div class="info-linha" style="align-items:flex-start; padding: 0.8rem; background:var(--azul-claro); border-radius:10px; margin-bottom:0.7rem;">
    <i class="fa fa-graduation-cap" style="margin-top:3px;"></i>
    <div>
    <p style="font-weight:700; color:var(--azul-escuro);">${f.grau}</p>
    <p style="font-size:0.85rem; color:var(--cinza-claro);">${f.instituicao} · ${f.ano}</p>
    </div>
    </div>
    `).join('')}
  </div>

  <!-- ABA: Experiência Profissional -->
  <div class="modal-aba-conteudo" id="aba-experiencia">
  ${psi.experiencia.map(e => `
    <div class="info-linha" style="align-items:flex-start; padding: 0.8rem; background:var(--azul-claro); border-radius:10px; margin-bottom:0.7rem;">
    <i class="fa fa-briefcase" style="margin-top:3px;"></i>
    <div>
    <p style="font-weight:700; color:var(--azul-escuro);">${e.cargo}</p>
    <p style="font-size:0.85rem; color:var(--cinza-claro);">${e.local} · ${e.periodo}</p>
    </div>
    </div>
    `).join('')}
  </div>

  <!-- ABA: Informações Pessoais -->
  <div class="modal-ab